class Panel
  attr_accessor :panel

  def initialize(height = 100, width = 100, top = 0, left = 0)
    @panel =  Curses::Window.new(height, width, top, left)
  end

  def close
    Curses.close_screen
  end
end