require './lib/house_mouse'

RSpec.describe Tcp do
  describe '.initialize' do
    before { ipv4 }
    subject { Tcp.new(ipv4.data) }

    let(:ethernet) { Ethernet.new(File.read('./spec/fixtures/ipv4_packet')) }
    let(:ipv4) { Ipv4.new(ethernet.data) }

    let(:flags) do
      {
        cwr: '0',
        ece: '0',
        urg: '0',
        ack: '0',
        psh: '0',
        rst: '0',
        syn: '1',
        fin: '0'
      }
    end

    it { is_expected.to be_a Tcp }
    it { expect(subject.dest_port).to eq(80) }
    it { expect(subject.src_port).to eq(148_194) }
    it { expect(subject.flags).to eq(flags) }
  end
end
