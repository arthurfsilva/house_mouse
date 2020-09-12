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

    raw_data_re = []
    
    raw_data.each_byte { raw_data_re << _1.to_i }
    
    @src_port = raw_data_re[0..1].join.to_i
    @dest_port = raw_data_re[2..3].join.to_i
    offset = raw_data_re[12] >> 4
    
    @data = raw_data[offset...] 
  end
end

