require_relative 'widgets/window'

class RequestPanel < Gui::Widgets::Window
  def initialize(height:, width:, top: 0, left: 0)
    super(height, width, top, left)

    @header = %w[Source Destination Protocol Info Flags]
    render_content([])
  end

  def render_content(requests, selected_row = 0)
    requests.unshift(@header)

    render_window.then { render_table(requests, selected_row) }

    refresh
  end

  def render_body(request)
    clear.then { render_window }

    render_body_header(request)

    self.print(3, 3, request[:flags], 3)
    self.print(5, 2, 'Data:')

    request[:data]&.split("\n")&.each_with_index { |line, index| self.print(index + 6, 8, line) }

    refresh
  end

  private

  def render_body_header(request)
    request = request.filter do |k, _v|
      %i[source destination protocol info].include?(k)
    end

    request.map { "#{_1[0].capitalize}: #{_1[1]} | " }.join.then { self.print(2, 2, _1) }
  end
end
