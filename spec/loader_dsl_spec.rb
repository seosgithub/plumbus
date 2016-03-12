require './spec/spec_helper.rb'

describe Plumbus::LoaderDSL do
  include_context 'with config'
  let(:dsl) { Plumbus::LoaderDSL.new config_path }

  describe '#ports' do
    let(:ports) { dsl.ports }
    subject { ports }

    it { should all(include :config_block) }

    describe '#count' do
      subject { ports.count }
      it { should == 3 }
    end

    describe 'first port' do
      subject { ports.first }
      it { should include :direction => port0_direction, :driver => driver }
    end

    describe 'second port' do
      subject { ports[1] }
      it { should include :direction => port1_direction, :driver => driver }
    end
  end

  context 'config with invalid port direction' do
    let(:port0_direction) { :invalid_direction }

    it 'raises error about invalid direction' do
      expect { dsl }.to raise_error ArgumentError, /#{port0_direction}.*request.*response/
    end
  end

  context 'config with port without config block' do
    let(:port0_config_block) { "" }

    it 'raises error about invalid direction' do
      expect { dsl }.to raise_error ArgumentError, /config block/
    end
  end
end
