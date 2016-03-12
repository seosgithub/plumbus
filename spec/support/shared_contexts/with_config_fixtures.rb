require 'tempfile'

shared_context 'with config' do
  let(:config_path) { config.to_file }

  let(:driver) { :plumbus_fake_driver }
  let(:port0_direction) { :request }
  let(:port1_direction) { :response }
  let(:port2_direction) { :response }

  let(:port0_supports_actions_names0) { :foo }
  let(:port0_supports_actions) {%{
    supports_actions :#{port0_supports_actions_names0}
  }}
  let(:port0_config_block) {%{{
    #{port0_supports_actions}
  }}}

  let(:port1_supports_actions_names0) { :foo }
  let(:port1_supports_actions) {%{
    supports_actions :#{port1_supports_actions_names0}
  }}
  let(:port1_config_block) {%{{
    #{port1_supports_actions}
  }}}

  let(:port2_supports_actions_names0) { :foo2 }
  let(:port2_supports_actions) {%{
    supports_actions :#{port2_supports_actions_names0}
  }}
  let(:port2_config_block) {%{{
    #{port2_supports_actions}
  }}}

  let(:port0) { "port(:#{port0_direction}, :#{driver}) #{port0_config_block}" }
  let(:port1) { "port(:#{port1_direction}, :#{driver}) #{port1_config_block}" }
  let(:port2) { "port(:#{port2_direction}, :#{driver}) #{port2_config_block}" }

  let(:config) do
    %{
      #{port0}
      #{port1}
      #{port2}
    }
  end
end

shared_context 'with bad config' do
  let(:config_path) { 
    file = Tempfile.new('bogus.rb')
    file.write File.read './spec/fixtures/configs/bogus.rb'
    file.close
    return file.path
  }
end
