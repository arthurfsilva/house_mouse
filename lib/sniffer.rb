class Sniffer
  def self.start(socket, request_panel)
    requests = []

    40.times do # TODO Change to 15 seconds
      raw_data, addr = socket.recvfrom(65535)
      
      ethernet = Ethernet.new(raw_data)
      
      if ethernet.ipv4?
        ipv4 = Ipv4.new(ethernet.data)
        
        if ipv4.tcp?
          tcp = Tcp.new(ipv4.data)
          
          if tcp.src_port == 80 || tcp.dest_port == 80
            requests << {
              source: "#{ipv4.src}:#{tcp.src_port}",
              destination: "#{ipv4.dest}:#{tcp.dest_port}",
              data: Http.new(tcp.data).data,
              protocol: 'TCP'
            }
            
            request_panel.render_content(requests)
          end
        end
      end
    end
    
    requests
  end
end