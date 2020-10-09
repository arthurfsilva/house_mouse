class MenuPanel < Panel
  def initialize(height:, width:, top:, left:)
    super(height, width, top, left)

    redraw
  end

  def redraw(items = { s: 'Start', f: 'Filter', c: 'Clear', sb: 'SortBy', h: 'Help', q: 'Quit' })
    @panel.clear
    items.each { @panel << " [#{_1[0].upcase}] #{_1[1]}" }.then { @panel.refresh }
    @panel.refresh
  end

  def handle_keyboard(request_panel)
    index = 0
    requests = []

    socket = Socket.new(17, 3, 768)
    @panel.keypad = true

    loop do
      chr = @panel.getch

      case chr
      when 's'
        redraw({ s: 'Stop', f: 'Filter', c: 'Clear', sb: 'Sortby', h: 'Help', q: 'Quit' })
        requests = Sniffer.start(socket, request_panel)
        redraw
      when 'f'
        redraw(filter: ' ')

        char = ''
        input = ''

        while input != 10
          input = @panel.getch
          
          if input == 127          
            char = char.chop
            input = ''
          else
            char += input
          end
          
          @panel << input

          requests = requests.filter do |request|
            request[:destination].match(char) || request[:source].match(char) || request[:protocol].match(char)
          end
          
          Sniffer.filter(requests, request_panel)
        end
      when 'c'
        request_panel.draw_window
      when 'h'
        puts 'Help'
      when 'q'
        close
        exit(0)
      when KEY_UP
        if index > 0
          index -= 1 
          request_panel.render_content(requests, index)
        end
      when KEY_DOWN
        if index < requests.length - 1
          index += 1 
          request_panel.render_content(requests, index)
        end
      when 10
        redraw({ b: 'Back'})
        request_panel.render_body(requests[index])        
      when 'b'
        redraw
        request_panel.render_content(requests, index)
      end
    end
  end
end
