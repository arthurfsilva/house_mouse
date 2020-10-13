require 'hexdump'

class Ipv4
  attr_accessor :data, :version, :src, :proto, :dest, :header_length

  TCP = 6

  def initialize(raw_data)
    data = raw_data.unpack('C*')

    version_header_length = data[0]

    @version = version_header_length >> 4
    @header_length = (version_header_length & 15) * 4

    @proto = data[9]
    @src = data[12..15].then { to_ipv4(_1) }
    @dest = data[16..19].then { to_ipv4(_1) }
    @data = raw_data[@header_length..]
  end

  def tcp?
    @proto == TCP
  end

  def to_ipv4(addr)
    addr.join('.')
  end
end
