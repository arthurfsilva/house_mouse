module Gui
  module Widgets
    class Table
      def initialize(window, table, index)
        prepare_table(window, table, index).then { render_header.then { render_body } }
      end

      def row(line)
        raise StandardError, 'Line must be a positive number' if line.negative?

        @table[line]
      end

      private

      def render_header
        prepare_header(@table.first).then do |header|
          @window.print(1, 4, header, Curses::COLOR_BLUE)
        end

        @table.shift
      end

      def render_body
        @table.each_with_index do |request, key|
          color = Curses::COLOR_RED if key == @index

          prepare_body(request).then { @window.print(key + 2, 4, _1, color) }
        end
      end

      def prepare_table(window, table, index = 0)
        raise StandardError, 'Table must be a Array' unless table.is_a? Array
        raise StandardError, 'Window must be a instance of Curses::Window' unless window.is_a? Window

        @table = table
        @index = index
        @window = window
      end

      def prepare_header(header)
        mount_table(header)
      end

      def prepare_body(body)
        items = body.values
        items.delete_at(3)
        mount_table(items)
      end

      def mount_table(data)
        items = []
        table_data_size = (Curses.cols / 5) - 10

        data.each_with_index do |h, index|
          items[index] = h.ljust(table_data_size, ' ') + '| '
        end

        items.join
      end
    end
  end
end
