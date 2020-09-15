class MenuPanel < Panel
  def initialize(height:, width:, top:, left:)
    super(height, width, top, left)
    
    redraw() 
  end

  def redraw(items = {s: 'Start', f: 'Filter', c: 'Clear', sb: 'Sortby', h: 'Help', q: 'Quit' })
    @panel.clear
    items.each { @panel << " [#{_1[0].upcase}] #{_1[1]}" }.then { @panel.refresh  }
  end

  def handle_keyboard(request_panel)
    index = 0  
    requests = []

    socket = Socket.new(17, 3, 768)

    while true
      chr = @panel.getch
      
      case chr
      when 's'
        redraw({s: 'Stop', f: 'Filter', c: 'Clear', sb: 'Sortby', h: 'Help', q: 'Quit' })
        requests = Sniffer.start(socket, request_panel)
        redraw()
      when 'f'
        puts 'filter'
      when 'c'
        puts 'clear'
        request_panel.draw_window
      when 'h'
        puts 'Help'
      when 'q'
        close()
        exit(0)
      when 'j'
        index += 1 if index < requests.length
        request_panel.render_content(requests, index)
      when 'k'
        index -= 1 if index > 0
        request_panel.render_content(requests, index)
      when 10
        request_panel.render_body(requests[index])
      when 'b'
        request_panel.render_content(requests, index)
      end

      @panel.refresh
    end
  end
end