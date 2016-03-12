require './spec/spec_helper.rb'

describe Hash do
  describe '#trim!' do
    subject { example.trim! }

    describe 'hash' do
      let(:example) {
        {
          :a => [
            :b => {
              :c => [:a, :b],
              :d => [:a => {:b => [[]]}]
            }, 
            :c => {}
          ]
        }
      }

      it { should eq(:a => [
        :b => { :c => [:a, :b]}
      ]) }
    end

    describe 'array' do
      let(:example) {
        [:a, :b => [:c, {:d => [{:e => [{:f => [{:c => []}]}]}]}]]
      }

      it { should eq([:a, :b => [:c]]) }
    end
  end
end
