class MenuPanel < Panel
  def initialize(height:, width:, top:, left:)
    super(height, width, top, left)
    
    redraw() 
  end

  def redraw(items = {s: 'Start', f: 'Filter', e: 'Search', sb: 'Sortby', h: 'Help', q: 'Quit' })
    @panel.clear
    items.each { @panel << " [#{_1[0].upcase}] #{_1[1]}" }
    @panel.refresh
  end
end