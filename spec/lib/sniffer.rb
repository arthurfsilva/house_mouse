require 'net/http'
require './lib/house_mouse'

# FIXME
RSpec.describe Sniffer do
  describe '.start' do
    threads = []

    let(:packet) { File.read('./spec/fixtures/ipv4_packet') }

    socket = Socket.new(17, 3, 768)

    threads << Thread.new { Sniffer.start(socket, RequestPanel.new(height: 0, width: 0)) }
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
