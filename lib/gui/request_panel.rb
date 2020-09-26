require_relative 'panel'

class RequestPanel < Panel
  def initialize(height:, width:, top: 0, left: 0)
    super(height, width, top, left)

    @panel.keypad(true)
    @panel.nodelay = true
    render_content([])
  end

  def render_content(requests, index = 0)
    draw_window

    requests.each_with_index do |request, key|
      @panel.setpos(key + 2, 2)
      @panel << '-> ' if key == index
      @panel.addstr("Source: #{request[:source]} | Destination: #{request[:destination]} | Protocol: #{request[:protocol]}")
      @panel.setpos(key + 3, 2)
      @panel.addstr('')
      @panel.setpos(key + 4, 8)
    end

    @panel.refresh
  end

  def render_body(request)
    draw_window
    @body_viewer = true

    @panel.setpos(2, 2)
    @panel.addstr("Source: #{request[:source]} | Destination: #{request[:destination]} | Protocol: #{request[:protocol]}")
    @panel.setpos(4, 2)
    @panel.addstr('Data: ')

    request[:data]&.split("\n")&.each_with_index do |line, index|
      @panel.setpos(index + 4, 8)
      @panel << line
    end

    @panel.refresh
  end

  def draw_window
    @panel.clear

    @panel.box('|', '_', '+')
    @panel.refresh
  end
end
