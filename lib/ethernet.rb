require 'socket'
require 'pry'

class Ethernet
  attr_accessor :dest, :src, :proto, :data

  def initialize(raw_data)
      dest = raw_data[0...5]
      src = raw_data[6..11]
      protocol = raw_data[12..13].unpack('h').first.to_i

      @dest = get_mac_addr(dest)
      @src = get_mac_addr(src)
      @proto = protocol
      @data = raw_data[14...]
  end

  def ipv4?
    @proto == 8
  end

  def get_mac_addr(mac_raw)
    mac_addr = ''
    mac_raw.each_byte do |a|
      mac_addr += "#{a.to_s(16)}:"
    end
  end
end


