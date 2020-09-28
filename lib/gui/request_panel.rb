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
    @panel.setpos(1, 2)
    @panel.addstr("|   Source \t\t\t| Destination \t\t\t| Protocol \t\t | Info \t\t |")
    @panel.setpos(2, 2)
    @panel.addstr("|_____________________________|_______________________________|________________________|_______________________|")
    
    requests.each_with_index do |request, key|
      @panel.setpos(key + 3, 2)
      @panel << '-> ' if key == index

      info = request[:data]&.split("\n")[0]&.slice(0..14)&.rstrip
      
      @panel.setpos(key + 3, 5)
     
      @panel.addstr(
        "#{request[:source]}\t\t| #{request[:destination].rstrip} \t\t| #{request[:protocol].rstrip}  \t\t\t | #{ info } ")

      @panel.setpos(key + 4, 2)

      @panel.addstr('')
      @panel.setpos(key + 5, 8)
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
