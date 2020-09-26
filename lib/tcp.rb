class Tcp
  attr_accessor :data, :src_port, :dest_port, :sequence, :acknowledgment, :flags

  def initialize(raw_data)
    data = raw_data.unpack('C*')

    @flags = { #TODO Implement this flags
      urg: nil,
      ack: nil,
      psh: nil,
      rst: nil,
      syn: nil,
      fin: nil
    }
    
    @src_port = data[0..1].join.to_i
    @dest_port = data[2..3].join.to_i
    offset = data[12] >> 4
    
    @data = raw_data[offset...] 
  end
end

