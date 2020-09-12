require 'hexdump'

class Ipv4
  attr_accessor :data, :version, :src, :proto, :dest
  
  def initialize(raw_data)
    
    version_header_length = 0
    raw_data_re = []

    raw_data.each_byte do
      if _1 == nil
        raw_data_re << _1
      else
        raw_data_re << _1.to_i
      end
    end

    version_header_length = raw_data_re[0]
  
    @version = version_header_length >> 4
    @header_length = (version_header_length & 15) * 4

    @proto =  raw_data_re[9]
    @src = raw_data_re[12..15]
    @dest = raw_data_re[16..19]
    
    @src = ipv4(@src)
    @dest = ipv4(@dest)
    @data = raw_data[@header_length...]
  end

  def ipv4(addr)
    addr.join('.')
  end
end
