require './spec/spec_helper'

#Facility functions are tested as they are imported inside a driver (Port)
describe "Driver facilities & Routing" do
  include_context 'with config'
  include_context 'with plumbus_fake_driver gem in load path'
  before(:each) { Plumbus::Loader.load(config_path) } 

  subject { response_instance }

  context 'when calling invalidate_supported_actions' do
    let(:action_name) { "bar" }
    before { response_instance._spec_expand_and_invalidate_supported_actions action_name }

    describe 'routed to correct location' do
      let(:response_ports_for_request) { Plumbus::Ports.response_ports_for_request(action: action_name) }

      describe '#count' do
        subject { response_ports_for_request.count }
        it { should equal(1) }
      end
    end
  end

  let(:response_instance) { Plumbus::Ports.instances.select{|e| e.direction == :response}.first }
  let(:request_instance) { Plumbus::Ports.instances.select{|e| e.direction == :request}.first }
  let(:response2_instance) { Plumbus::Ports.instances.select{|e| e.direction == :response}[1] }

  let(:request_received_messages) { request_instance._spec_received_messages }
  let(:response_received_messages) { response_instance._spec_received_messages }
  let(:response2_received_messages) { response2_instance._spec_received_messages }
  let(:request_received_signals) { request_instance._spec_received_signals }
  let(:response_received_signals) { response_instance._spec_received_signals }
  let(:response2_received_signals) { response2_instance._spec_received_signals }
  let(:request_sid) { 'session' }
  let(:request_action) { 'foo' }
  let(:request_payload) { 'holah'}
  let(:response_sid) { 'session' }
  let(:response_action) { 'foo' }
  let(:response_payload) { 'holah'}
  let(:response2_sid) { 'session' }
  let(:response2_action) { 'foo2' }
  let(:response2_payload) { 'holah' }

  let(:wanted_request_received_signal_count) { 0 }
  let(:wanted_request_received_message_count) { 0 }
  let(:wanted_request_first_message_sid) { request_sid }
  let(:wanted_request_first_message_action) { request_action }
  let(:wanted_request_first_message_payload) { request_payload }
  let(:wanted_request_first_signal_info) { {} }
  let(:wanted_request_first_signal_name) { '' }

  let(:wanted_response_received_signal_count) { 0 }
  let(:wanted_response_received_message_count) { 0 }
  let(:wanted_response_first_message_sid) { response_sid }
  let(:wanted_response_first_message_action) { response_action }
  let(:wanted_response_first_message_payload) { response_payload }
  let(:wanted_response_first_signal_info) { {} }
  let(:wanted_response_first_signal_name) { '' }

  let(:wanted_response2_received_signal_count) { 0 }
  let(:wanted_response2_received_message_count) { 0 }
  let(:wanted_response2_first_message_sid) { response2_sid }
  let(:wanted_response2_first_message_action) { response2_action }
  let(:wanted_response2_first_message_payload) { response2_payload }
  let(:wanted_response2_first_signal_info) { {} }
  let(:wanted_response2_first_signal_name) { '' }


  def make_request(action=nil) request_instance._spec_emit_message request_sid, action || request_action, request_payload end 
  def make_response() response_instance._spec_emit_message response_sid, response_action, response_payload end 
  def make_response2() response2_instance._spec_emit_message response2_sid, response2_action, response2_payload end 

  shared_examples_for 'request & response states' do
    describe 'request state' do
      describe 'received message count' do
        subject { request_received_messages.count }
        it { should equal(wanted_request_received_message_count) }
      end

      describe 'received signal count' do
        subject { request_received_signals.count }
        it { should equal(wanted_request_received_signal_count) }
      end

      describe 'first message' do
        subject { request_received_messages.first }
        it 'has the correct first message' do
          if wanted_request_received_message_count != 0
            expect(request_received_messages.first).to include(:sid => wanted_request_first_message_sid)
            expect(request_received_messages.first).to include(:action => wanted_request_first_message_action)
            expect(request_received_messages.first).to include(:payload => wanted_request_first_message_payload)
          end
        end
      end

      describe 'first signal' do
        subject { request_received_signals.first }
        it 'has the correct first signal' do
          if wanted_request_received_signal_count != 0
            expect(request_received_signals.first).to include(:name => wanted_request_first_signal_name)
            expect(request_received_signals.first).to include(:info => wanted_request_first_signal_info)
          end
        end
      end
    end

    describe 'response state' do
      describe 'received message count' do
        subject { response_received_messages.count }
        it { should equal(wanted_response_received_message_count) }
      end

      describe 'received signal count' do
        subject { response_received_signals.count }
        it { should equal(wanted_response_received_signal_count) }
      end

      describe 'first message' do
        it 'has the correct first message' do
          if wanted_response_received_message_count != 0
            expect(response_received_messages.first).to include(:sid => wanted_response_first_message_sid)
            expect(response_received_messages.first).to include(:action => wanted_response_first_message_action)
            expect(response_received_messages.first).to include(:payload => wanted_response_first_message_payload)
          end
        end
      end

      describe 'first signal' do
        subject { response_received_signals.first }
        it 'has the correct first signal' do
          if wanted_response_received_signal_count != 0
            expect(response_received_signals.first).to include(:name => wanted_response_first_signal_name)
            expect(response_received_signals.first).to include(:info => wanted_response_first_signal_info)
          end
        end
      end
    end

    describe 'response2 state' do
      describe 'received message count' do
        subject { response2_received_messages.count }
        it { should equal(wanted_response2_received_message_count) }
      end

      describe 'received signal count' do
        subject { response2_received_signals.count }
        it { should equal(wanted_response2_received_signal_count) }
      end

      describe 'first message' do
        it 'has the correct first message' do
          if wanted_response2_received_message_count != 0
            expect(response2_received_messages.first).to include(:sid => wanted_response2_first_message_sid)
            expect(response2_received_messages.first).to include(:action => wanted_response2_first_message_action)
            expect(response2_received_messages.first).to include(:payload => wanted_response2_first_message_payload)
          end
        end
      end

      describe 'first signal' do
        subject { response2_received_signals.first }
        it 'has the correct first signal' do
          if wanted_response2_received_signal_count != 0
            expect(response2_received_signals.first).to include(:name => wanted_response2_first_signal_name)
            expect(response2_received_signals.first).to include(:info => wanted_response2_first_signal_info)
          end
        end
      end
    end

  end

  context 'when message is forwarded from request => response' do
    before { make_request }
    it_behaves_like 'request & response states'
    let(:wanted_response_received_message_count) { 1 }
  end

  context 'when message is forwarded from request => response2' do
    before { make_request(port2_supports_actions_names0) }
    it_behaves_like 'request & response states'
    let(:wanted_response2_received_message_count) { 1 }
  end

  context 'when an un-deliverable message is forwarded from request => response' do
    let(:request_action) { 'undeliverable' }
    before { make_request }
    it_behaves_like 'request & response states'
    let(:wanted_request_received_signal_count) { 1 }
    let(:wanted_request_first_signal_info) {{:sid => request_sid }}
    let(:wanted_request_first_signal_name) {:undeliverable}
  end

  context 'when an un-deliverable message is forwarded from repsonse => request' do
    let(:request_action) { 'undeliverable' }
    before { make_response }
    it_behaves_like 'request & response states'
    let(:wanted_response_received_signal_count) { 1 }
    let(:wanted_response_first_signal_info) {{:sid => response_sid }}
    let(:wanted_response_first_signal_name) {:undeliverable}
  end

  context 'when message is forwarded from response => request' do
    before { make_response }

    it_behaves_like 'request & response states'
    let(:wanted_response_received_signal_count) { 1 }
    let(:wanted_response_first_signal_info) {{:sid => request_sid }}
    let(:wanted_response_first_signal_name) {:undeliverable}
  end

  context 'when message is forwarded from request => response => request' do
    before do
      make_request
      make_response
    end

    it_behaves_like 'request & response states'
    let(:wanted_request_received_message_count) { 1 }
    let(:wanted_response_received_message_count) { 1 }
  end

  context 'when message is forwarded from (request => response)x2 and the request side signals terminates' do
    before do
      make_request
      make_request
      request_instance.raise_signal :hangup, {:sid => request_sid}
    end

    it_behaves_like 'request & response states'
    let(:wanted_response_received_signal_count) { 1 }
    let(:wanted_response_received_message_count) { 2 }
    let(:wanted_response_first_signal_info) {{:sid => request_sid }}
    let(:wanted_response_first_signal_name) {:hangup_notice}
  end

  context 'when message is forwarded from (request => response)x2 and the response side signals terminates' do
    before do
      make_request
      make_request
      response_instance.raise_signal :hangup, {:sid => request_sid}
    end

    it_behaves_like 'request & response states'
    let(:wanted_response_received_signal_count) { 0 }
    let(:wanted_response_received_message_count) { 2 }

    let(:wanted_request_received_signal_count) { 1 }
    let(:wanted_request_received_message_count) { 0 }
    let(:wanted_request_first_signal_info) {{:sid => request_sid }}
    let(:wanted_request_first_signal_name) {:hangup_notice}
  end

  #Multiple responses are open, request should never get a termiantion until all responses hangup
  context 'when message is forwarded from request => responseA, request => responseB, and the responseA side signals terminates' do
    before do
      make_request
      make_request(port2_supports_actions_names0)
      response_instance.raise_signal :hangup, {:sid => request_sid}
    end

    it_behaves_like 'request & response states'
    let(:wanted_response_received_message_count) { 1 }
    let(:wanted_response2_received_message_count) { 1 }

    let(:wanted_request_received_signal_count) { 0 }
    let(:wanted_request_received_message_count) { 0 }
  end

  context 'when message is forwarded from request => responseA, request => responseB, and the responseA & responseB side signals terminates' do
    before do
      make_request
      make_request(port2_supports_actions_names0)
      response_instance.raise_signal :hangup, {:sid => request_sid}
      response2_instance.raise_signal :hangup, {:sid => request_sid}
    end

    it_behaves_like 'request & response states'
    let(:wanted_response_received_message_count) { 1 }
    let(:wanted_response2_received_message_count) { 1 }

    let(:wanted_request_received_signal_count) { 1 }
    let(:wanted_request_received_message_count) { 0 }
    let(:wanted_request_first_signal_name) {:hangup_notice}
    let(:wanted_request_first_signal_info) {{:sid => request_sid }}
  end

  context 'when message is forwarded from request => responseA, request => responseB with the same session and the request side signals terminates' do
    before do
      make_request

      make_request(port2_supports_actions_names0)
      request_instance.raise_signal :hangup, {:sid => request_sid}
    end

    it_behaves_like 'request & response states'
    let(:wanted_response_received_signal_count) { 1 }
    let(:wanted_response_received_message_count) { 1 }
    let(:wanted_response_first_signal_info) {{:sid => request_sid }}
    let(:wanted_response_first_signal_name) {:hangup_notice}

    let(:wanted_response2_received_signal_count) { 1 }
    let(:wanted_response2_received_message_count) { 1 }
    let(:wanted_response2_first_signal_info) {{:sid => request_sid }}
    let(:wanted_response2_first_signal_name) {:hangup_notice}
  end
end
