require 'socket'
require 'pry'
require 'curses'
require_relative 'house_mouse/ethernet'
require_relative 'house_mouse/ipv4'
require_relative 'house_mouse/tcp'
require_relative 'house_mouse/http'
require_relative 'house_mouse/sniffer'
require_relative 'house_mouse/gui/request_panel'
require_relative 'house_mouse/gui/menu_panel'
require_relative 'house_mouse/gui/widgets/window'

module HouseMouse
  NAME = 'House Mouse'.freeze
  VERSION = '1.0.0'.freeze
end
