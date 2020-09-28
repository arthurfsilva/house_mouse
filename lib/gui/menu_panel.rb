class MenuPanel < Panel
  def initialize(height:, width:, top:, left:)
    super(height, width, top, left)

    redraw
  end

  def redraw(items = { s: 'Start', f: 'Filter', c: 'Clear', sb: 'SortBy', h: 'Help', q: 'Quit' })
    @panel.clear
    items.each { @panel << " [#{_1[0].upcase}] #{_1[1]}" }.then { @panel.refresh }
  end

  def handle_keyboard(request_panel)
    index = 0
    requests = []

    socket = Socket.new(17, 3, 768)

    loop do
      chr = @panel.getch

      case chr
      when 's'
        redraw({ s: 'Stop', f: 'Filter', c: 'Clear', sb: 'Sortby', h: 'Help', q: 'Quit' })
        requests = Sniffer.start(socket, request_panel)
        redraw
      when 'f'
        redraw(filter: ' ')

        Curses.echo

        char = ''
        input = ''

        while input != 10 # TODO: backspace
          input = @panel.getch

          puts input

          if input == 127          
            char = char.chop
          else
            char += input
          end
          
          requests = requests.filter { |request| request[:destination].match(char) }
          
          Sniffer.filter(requests, request_panel)
        end
      when 'c'
        puts 'clear'
        request_panel.draw_window
      when 'h'
        puts 'Help'
      when 'q'
        close
        exit(0)
      when 'j'
        index += 1 if index < requests.length
        request_panel.render_content(requests, index)
      when 'k'
        index -= 1 if index > 0
        request_panel.render_content(requests, index)
      when 10
        redraw({ b: 'Back'})
        request_panel.render_body(requests[index])        
      when 'b'
        redraw({ s: 'Start', f: 'Filter', c: 'Clear', sb: 'Sortby', h: 'Help', q: 'Quit' })
        request_panel.render_content(requests, index)
      end

      @panel.refresh
    end
  end
end
