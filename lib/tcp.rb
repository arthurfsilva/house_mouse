class Tcp
  attr_accessor :data, :src_port, :dest_port, :sequence, :acknowledgment, :flags

  def initialize(raw_data)
    data = raw_data.unpack('C*')

    @flags = {
      cwr: nil,
      ece: nil,
      urg: nil,
      ack: nil,
      psh: nil,
      rst: nil,
      syn: nil,
      fin: nil
    }
    
    @src_port = data[0..1].join.to_i
    @dest_port = data[2..3].join.to_i
    @sequence = data[4..7]
    @acknowledgment = data[8..11]

    @flags[:cwr], @flags[:ece], @flags[:urg], @flags[:ack], @flags[:psh], @flags[:rst], @flags[:syn], @flags[:fin] = data[13].to_s(2).rjust(8, '0').chars

    offset = data[12] >> 4
    offset = offset * 4
  
    @data = raw_data[offset...]
  end
end
