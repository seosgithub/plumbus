require './spec/spec_helper'

describe Plumbus::FileGenerators do
  let(:dir) { Dir.mktmpdir }
  subject do 
    Dir["#{dir}/*"].map{|e| Pathname(e).relative_path_from(Pathname(dir)).to_s}
  end

  describe '#new_project' do
    before { Plumbus::FileGenerators.new_project dir }

    it {
      should include("Gemfile")
    }
  end
end
