require_relative './table'

module Gui
  module Widgets
    class Window
      attr_accessor :panel

      class << self
        def init
          Curses.init_screen
          Curses.curs_set(0)
          Curses.noecho
          Curses.start_color

          Curses.init_pair(Curses::COLOR_BLUE, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
          Curses.init_pair(Curses::COLOR_RED, Curses::COLOR_BLACK, Curses::COLOR_MAGENTA)
          Curses.init_pair(3, Curses::COLOR_BLACK, Curses::COLOR_GREEN)
        end

        def lines
          Curses.lines
        end

        def cols
          Curses.cols
        end
      end

      def initialize(height = 100, width = 100, top = 0, left = 0)
        @panel = Curses::Window.new(height, width, top, left)
      end

      def render_table(table, selected_row)
        Gui::Widgets::Table.new(self, table, selected_row)
      end

      def render_window
        @panel.box('|', '_', '+')
      end

      def print(row, col, content, color = 0)
        color = Curses.color_pair(color.to_i) | Curses::A_NORMAL

        @panel.setpos(row, col)
        @panel.attron(color) do
          @panel << content
        end
      end

      def refresh
        @panel.refresh
      end

      def clear
        @panel.clear
      end

      def close
        Curses.close_screen
      end
    end
  end
end
