require 'socket'
require 'pry'
require './ethernet'
require './ipv4'
require './tcp'

include Socket::Constants

socket = Socket.new(17, 3, 768)

while true
  begin # emulate blocking recvfrom
    raw_data, addr = socket.recvfrom_nonblock(65535)
  rescue IO::WaitReadable
    IO.select([socket])
    retry
  end


  ethernet = Ethernet.new(raw_data)
  
  if ethernet.proto == 8
    ipv4 = Ipv4.new(ethernet.data)
    
    if ipv4.proto == 6
      tcp = Tcp.new(ipv4.data)
      
      if tcp.data != '' && (tcp.src_port == 80 || tcp.dest_port == 80)        
        puts("Http Frame:")
        puts("\t\t Source: #{ipv4.src_port}:#{tcp.src_port}, Destination: #{ipv4.dest_port}:#{tcp.dest_port}")
        puts("\t\t Data: #{tcp.data}")
        puts "<=============================>"
      end
    end
  end
end

socket.close
