require './spec/spec_helper'

describe Plumbus::FileGenerators do
  let(:_dir) { Dir.mktmpdir }
  let(:dir) { _dir }
  subject do 
    Dir["#{dir}/*"].map{|e| Pathname(e).relative_path_from(Pathname(dir)).to_s}
  end
  before { Plumbus::FileGenerators.new_project dir }

  describe '#new_project' do
    it { should include("routes.rb") }
    it { should include("Gemfile") }

    context "when dir doesn't exist" do
      let(:dir) { _dir + '/non_exstant' }

      it { should include("routes.rb") }
      it { should include("Gemfile") }
    end
  end
end
