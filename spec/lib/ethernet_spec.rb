require './lib/ethernet'

RSpec.describe Ethernet do
  describe '.initialize' do
    subject { Ethernet.new(File.read('./spec/fixtures/ipv4_packet')) }

    it { is_expected.to be_a Ethernet }
    it { expect(subject.ipv4?).to be true }
  end
end
