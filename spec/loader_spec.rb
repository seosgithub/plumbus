require './spec/spec_helper.rb'

describe Plumbus::Loader do
  include_context 'with config'
  include_context 'with plumbus_fake_driver gem in load path'
  before { Plumbus::Loader.load(config_path) } 

  #Loading ports should enter into the Ports manager
  describe 'Plumbus::Ports' do
    let(:port_instances) { Plumbus::Ports.instances }
    describe '#instances' do
      subject { port_instances }

      describe '#count' do
        subject { port_instances.count }
        it { should == 3 }
      end
    end

    describe '#response_ports_for_request for port1 action' do
      let(:response_ports_for_request) { Plumbus::Ports.response_ports_for_request(action: port1_supports_actions_names0) }
      subject { response_ports_for_request }

      describe '#count' do
        subject { response_ports_for_request.count }
        it { should eq(1) }
      end
    end

    describe '#response_ports_for_request for port2 action' do
      let(:response_ports_for_request) { Plumbus::Ports.response_ports_for_request(action: port2_supports_actions_names0) }
      subject { response_ports_for_request }

      describe '#count' do
        subject { response_ports_for_request.count }
        it { should eq(1) }
      end
    end

  end
end
