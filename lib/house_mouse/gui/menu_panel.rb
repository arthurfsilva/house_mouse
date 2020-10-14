require_relative 'widgets/window'

class MenuPanel < Gui::Widgets::Window
  KEY_S = 's'.freeze
  KEY_F = 'f'.freeze
  KEY_C = 'c'.freeze
  KEY_H = 'h'.freeze
  KEY_Q = 'q'.freeze
  KEY_B = 'b'.freeze
  KEY_ENTER = 10
  KEY_UP = Curses::KEY_UP
  KEY_DOWN = Curses::KEY_DOWN
  KEY_BACKSPACE = Curses::KEY_BACKSPACE

  def initialize(height:, width:, top:, left:)
    super(height, width, top, left)

    @panel.keypad = true
    @requests = []
    @index = 0
    @body_rendered = false

    redraw
  end

  def redraw(items = { s: 'Start', f: 'Filter', c: 'Clear', h: 'Help', q: 'Quit' })
    @panel.clear
    items.each { @panel << " [#{_1[0].upcase}] #{_1[1]}" }.then { @panel.refresh }
    @panel.refresh
  end

  def handle_keyboard(request_panel)
    @request_panel = request_panel

    loop { @panel.getch.then { mapped_keys(_1)&.call } }
  end

  private

  # rubocop:disable Metrics/MethodLength
  def mapped_keys(key)
    mapped_keys = {
      KEY_S => method(:start_sniffer),
      KEY_F => method(:filter),
      KEY_C => method(:clear_panel),
      KEY_H => method(:help),
      KEY_Q => method(:quit),
      KEY_B => method(:content_panel),
      KEY_UP => method(:key_up),
      KEY_DOWN => method(:key_down),
      KEY_ENTER => method(:select)
    }

    mapped_keys[key]
  end
  # rubocop:enable Metrics/MethodLength

  def start_sniffer
    socket = Socket.new(17, 3, 768)
    redraw({ s: 'Stop', f: 'Filter', c: 'Clear', h: 'Help', q: 'Quit' })
    @requests = Sniffer.start(socket, @request_panel)
    redraw
  end

  # rubocop:disable Metrics/MethodLength
  def filter
    redraw(filter: ' ')

    char = nil
    input = ''

    while char != 10
      char = @panel.getch

      if char == KEY_BACKSPACE
        input = input.chop
      elsif [KEY_UP, KEY_DOWN, KEY_ENTER].include?(char)
        break
      else
        input += char.to_s
      end

      redraw(filter: '')
      @panel << input

      Sniffer.filter(@requests, @request_panel, input)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def clear_panel
    @request_panel.render_content([])
  end

  def help
    puts 'Help'
  end

  def quit
    close
    exit(0)
  end

  def key_up
    return unless @index.positive? && @body_rendered == false

    @index -= 1
    @request_panel.render_content(@requests, @index)
  end

  def key_down
    return unless @index < @requests.length - 1 && @body_rendered == false

    @index += 1
    @request_panel.render_content(@requests, @index)
  end

  def select
    redraw({ b: 'Back' })

    @request_panel.render_body(@requests[@index])
    @body_rendered = true
  end

  def content_panel
    @body_rendered = false
    redraw
    @request_panel.clear
    @request_panel.render_content(@requests, @index)
  end
end
