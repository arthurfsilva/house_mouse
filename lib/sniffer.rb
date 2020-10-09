class Sniffer
  def self.start(socket, request_panel)
    requests = []

    50.times do # TODO: Change to 15 seconds
      raw_data, addr = socket.recvfrom(65_535)

      ethernet = Ethernet.new(raw_data)

      next unless ethernet.ipv4?

      ipv4 = Ipv4.new(ethernet.data)

      next unless ipv4.tcp?

      tcp = Tcp.new(ipv4.data)

      next unless tcp.src_port == 80 || tcp.dest_port == 80

      requests << {
        source: "#{ipv4.src}:#{tcp.src_port}",
        destination: "#{ipv4.dest}:#{tcp.dest_port}",
        data: Http.new(tcp.data).data,
        flags: tcp.flags,
        protocol: 'TCP'
      }

      request_panel.render_content(requests)
    end

    requests
  end

  def self.filter(requests, request_panel)
    request_panel.render_content(requests)
  end
end
