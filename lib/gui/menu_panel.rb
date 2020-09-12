class MenuPanel < Panel
  def initialize(height:, width:, top:, left:)
    super(height, width, top, left)
    
    @panel << "[F1 Help] [F2 Filter] [F3 Search] [F4 Sortby] [F5 Start] [F10 exit]"
    @panel.refresh
  end
end