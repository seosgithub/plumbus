require_relative './spec_helper.rb'

describe "plumbus executable" do
  let(:config_path) { '' }
  let(:args) { [config_path] }
  let(:bin_cmd) { SpecShell.new("./bin/plumbus", *args) }
  subject { bin_cmd }

  include_context 'with plumbus_fake_driver gem in load path'

  shared_examples 'fail to run' do
    it { should have_failed }
  end

  context 'with no options' do
    include_examples "fail to run"
  end

  #context 'with -g option' do
    #let(:dir) { Dir.mktmpdir }
    #let(:args) { %W{-g #{dir}}}

    #it { should have_succeeded }

    #describe 'dir' do
      #subject { Dir["#{dir}/*"] }

      #it { should include("Gemfile") }
    #end
  #end

  context 'with bad config' do
    include_context 'with bad config'
    include_examples "fail to run"
  end

  context 'with config' do
    include_context 'with config'

      it { should have_timed_out }
    end
end
