require 'socket'
require 'pry'
require './lib/ethernet'
require './lib/ipv4'
require './lib/tcp'
require './lib/http'
require './lib/gui/request_panel'
require './lib/gui/menu_panel'
require 'curses'

include Socket::Constants

socket = Socket.new(17, 3, 768)

Curses.init_screen
Curses.curs_set(0)
Curses.noecho

lines = Curses.lines
cols = Curses.cols

request_panel = RequestPanel.new(height: lines - 2, width: cols - 15)
menu_panel = MenuPanel.new(height: 5, width: cols, top: lines - 1, left: 0)

def start_sniffer(socket, request_panel)
  requests = []

  40.times do # TODO Change to 15 seconds
    raw_data, addr = socket.recvfrom(65535)

    ethernet = Ethernet.new(raw_data)
    
    if ethernet.proto == 8
      ipv4 = Ipv4.new(ethernet.data)
      
      if ipv4.proto == 6
        tcp = Tcp.new(ipv4.data)
        
        if tcp.src_port == 80 || tcp.dest_port == 80
          requests << { source: "#{ipv4.src}:#{tcp.src_port}", destination: "#{ipv4.dest}:#{tcp.dest_port}", data: Http.new(tcp.data).data, protocol: 'TCP' }
          request_panel.render_content(requests)
        end
      end
    end
  end
end

while true
  chr = menu_panel.panel.getch

  case chr
  when 's'
    menu_panel.redraw({s: 'Stop', f: 'Filter', e: 'Search', sb: 'Sortby', h: 'Help', q: 'Quit' })
    start_sniffer(socket, request_panel)
    menu_panel.redraw()
  when 'f'
    puts 'filter'
  when 'e'
    puts 'search'
  when 'h'
    puts 'Help'
  when 'q'
    menu_panel.close()
    exit(0)
  end

  menu_panel.panel.refresh
end

