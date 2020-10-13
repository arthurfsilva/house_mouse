class Http
  attr_reader :data

  def initialize(raw_data)
    @data = raw_data
  end
end
