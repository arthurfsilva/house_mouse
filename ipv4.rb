require 'hexdump'

class Ipv4
  attr_accessor :data, :version, :src_port, :proto, :dest_port
  
  def initialize(raw_data)
    
    version_header_length = 0
    raw_data_re = []

    raw_data.each_byte do
      if _1 == nil || 0
        raw_data_re << _1
      else
        raw_data_re << _1.to_i
      end
    end

    version_header_length = raw_data_re[0]
    
    @version = version_header_length >> 4
    @header_length = (version_header_length & 15) * 4
    
    #@ttl, @proto, @src_port, @dest_port = raw_data[..20].unpack('8x B B 2x 4s 4s')
    
    @proto =  raw_data_re[9]
    @src_port = raw_data_re[12...16]
    @dest_port = raw_data_re[16...20]
    
    @src_port = ipv4(@src_port)
    @dest_port = ipv4(@dest_port)
    @data = raw_data[@header_length...]
  end

  def ipv4(addr)
    addr.join('.')
  end
end
