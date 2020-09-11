class Tcp
  attr_accessor :data, :src_port, :dest_port, :sequence, :acknowledgment, :flags

  def initialize(raw_data)
    @flags = {
      urg: nil,
      ack: nil,
      psh: nil,
      rst: nil,
      syn: nil,
      fin: nil
    }

    @src_port, @dest_port, @sequence, @acknowledgment, @offset_reserved_flags = raw_data[...15].unpack('! H H L L H').map { _1.to_i }

    raw_data_re = []

    raw_data.each_byte { raw_data_re << _1.to_i }

    @src_port = raw_data_re[1..2]
    @dest_port = raw_data_re[3]
    

    offset = (@offset_reserved_flags >> 12) * 4

    @data = raw_data[32...] 
  end
end

