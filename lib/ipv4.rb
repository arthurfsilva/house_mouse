require 'hexdump'

class Ipv4
  attr_accessor :data, :version, :src, :proto, :dest
  
  def initialize(raw_data)
    data = raw_data.unpack('C*')

    version_header_length = data[0]
    
    @version = version_header_length >> 4
    @header_length = (version_header_length & 15) * 4

    @proto = data[9]
    @src = data[12..15]
    @dest = data[16..19]
    
    @src = ipv4(@src)
    @dest = ipv4(@dest)
    @data = raw_data[@header_length...]
  end

  def tcp?
    @proto == 6
  end

  def ipv4(addr)
    addr.join('.')
  end
end
