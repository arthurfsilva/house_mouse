require 'net/http'
require './lib/house_mouse'

class Panel
  def render_content(requests); end
end

RSpec.describe Sniffer do
  describe '.start' do
    threads = []
    socket = Socket.new(17, 3, 768)

    threads << Thread.new { Sniffer.start(socket, Panel.new) }
    threads << Thread.new { Net::HTTP.get('google.com', '/') }
    threads << Thread.new { Net::HTTP.get('facebook.com', '/') }
    threads << Thread.new { Net::HTTP.get('brasfoot.com', '/') }
    threads << Thread.new { Net::HTTP.get('google.com', '/') }

    requests = []

    threads.each do |t|
      t.join
      requests << t.value
    end

    it { expect(requests).to be_a Array }
    it do
      request = requests.first.first

      expect(request).to have_key(:source)
      expect(request).to have_key(:destination)
      expect(request).to have_key(:protocol)
      expect(request).to have_key(:data)
      expect(request).to have_key(:info)
      expect(request).to have_key(:flags)
    end
  end
end
