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

    # TODO Refactory
    @panel.setpos(1, 1)
    @panel.attron(color_pair(COLOR_BLUE)|A_NORMAL)
    @panel.addstr("|   Source \t\t\t| Destination \t\t\t| Protocol \t\t | Info \t\t | Flags \t\t\t\t\t\t\t\t   |")
    @panel.attroff(color_pair(COLOR_BLUE)|A_NORMAL)

    requests.each_with_index do |request, key|
      @panel.setpos(key + 3, 2)
      @panel << '-> ' if key == index

      info = request[:data]&.split("\n")[0]&.slice(0..14)&.rstrip
      
      @panel.setpos(key + 3, 5)
      
      flags = ''
      request[:flags].each { flags += " #{_1[0].upcase}: #{_1[1]}, "  }
      
      # TODO Refactory
      if info.nil?
        info = " \t\t\t"
      else
        info += "\t"
      end
      
      if key == index
        @panel.attron(color_pair(COLOR_RED)|A_NORMAL)
      end

      @panel.addstr(
        "#{request[:source]}\t\t| #{request[:destination].rstrip} \t\t| #{request[:protocol].rstrip} \t\t\t | #{ info } | #{flags} "
      )

      if key == index
        @panel.attroff(color_pair(COLOR_RED)|A_NORMAL)
      end

      @panel.setpos(key + 4, 2)

      @panel.addstr('')
      @panel.setpos(key + 5, 8)
    end

    @panel.refresh
  end

  def render_body(request)
    draw_window

    @panel.setpos(2, 2)
    @panel.addstr("Source: #{request[:source]} | Destination: #{request[:destination]} | Protocol: #{request[:protocol]}")
    @panel.setpos(3, 3)

    flags = ''
    request[:flags].each { flags += " #{_1[0].upcase}: #{_1[1]}, "  }
    @panel.addstr(flags)

    @panel.setpos(5, 2)
    @panel.addstr('Data: ')

    request[:data]&.split("\n")&.each_with_index do |line, index|
      @panel.setpos(index + 6, 8)
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
