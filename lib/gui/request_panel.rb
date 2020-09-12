require_relative 'panel'

class RequestPanel < Panel
  def initialize(height:, width:, top: 0, left: 0)
    super(height, width, top, left)
    
    @panel.keypad(true)
    @panel.nodelay = true
    @panel.box('|', '_', '+')

    @panel.refresh
  end

  def render_content(requests)
    @panel.clear

    @panel.box('|', '_', '+')
    @panel.refresh

    top = 1
    requests.each_with_index do |request, index|
      @panel.setpos(index + 2, 2)
      @panel.addstr(" > Source: #{request[:source]} | Destination: #{request[:destination]} | Protocol: #{request[:protocol]}")
      @panel.setpos(index + 3, 2)
      @panel.addstr('')
      @panel.setpos(index + 4, 8)

      # @panel.addstr("Data: #{request[:data]}")
    end
    
    @panel.refresh
  end
end