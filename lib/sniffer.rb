class Sniffer
  def self.start(socket, request_panel)
    requests = []

    50.times do # TODO: Change to 15 seconds
      raw_data, _addr = socket.recvfrom(65_535)

      ethernet = Ethernet.new(raw_data)

      next unless ethernet.ipv4?

      ipv4 = Ipv4.new(ethernet.data)

      next unless ipv4.tcp?

      tcp = Tcp.new(ipv4.data)

      next unless tcp.src_port == 80 || tcp.dest_port == 80

      requests << {
        source: "#{ipv4.src}:#{tcp.src_port}",
        destination: "#{ipv4.dest}:#{tcp.dest_port}",
        protocol: 'TCP',
        data: Http.new(tcp.data).data,
        info: tcp.data&.slice(0..14)&.rstrip,
        flags: tcp.flags.filter { |_k, v| v == '1' }.map { " [#{_1[0].upcase}]" }.join
      }

      request_panel.render_content(requests)
    end

    requests
  end

  def self.filter(requests, request_panel, char = '')
    requests = requests.filter do |request|
      request[:destination].match(char) || request[:source].match(char) || request[:protocol].match(char)
    end

    request_panel.render_content(requests)
  end
end
