require 'socket'
require 'pry'
require 'curses'
require './lib/ethernet'
require './lib/ipv4'
require './lib/tcp'
require './lib/http'
require './lib/sniffer'
require './lib/gui/request_panel'
require './lib/gui/menu_panel'

Curses.init_screen
Curses.curs_set(0)
Curses.noecho

lines = Curses.lines
cols = Curses.cols

request_panel = RequestPanel.new(height: lines - 2, width: cols - 15)
menu_panel = MenuPanel.new(height: 5, width: cols, top: lines - 1, left: 0)
menu_panel.handle_keyboard(request_panel)