require_relative './spec_helper.rb'

describe "plumbus executable" do
  let(:config_path) { '' }
  let(:args) { [config_path] }
  subject { SpecShell.new("./bin/plumbus", *args) }

  include_context 'with plumbus_fake_driver gem in load path'

  shared_examples 'fail to run' do
    it { should have_failed }
  end

  context 'with no config' do
    include_examples "fail to run"
  end

  context 'with bad config' do
    include_context 'with bad config'
    include_examples "fail to run"
  end

  context 'with config' do
    include_context 'with config'

      it { should have_timed_out }
    end
end
