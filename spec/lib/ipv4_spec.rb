require './lib/ipv4'

RSpec.describe Ipv4 do
  describe '.initialize' do
    subject { Ipv4.new(ethernet.data) }

    let(:ethernet) { Ethernet.new(File.read('./spec/fixtures/ipv4_packet')) }

    it { is_expected.to be_a Ipv4 }
    it { expect(subject.tcp?).to be true }
    it { expect(subject.dest).to eq('172.217.28.78') }
    it { expect(subject.src).to eq('172.17.0.2') }
    it { expect(subject.header_length).to eq(20) }
    it { expect(subject.version).to eq(4) }
    it { expect(subject.data).not_to be_nil }
  end
end
