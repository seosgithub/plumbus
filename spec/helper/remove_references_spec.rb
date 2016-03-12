require './spec/spec_helper.rb'

describe Hash do
  describe '#remove_references!' do
    let(:object) { Object.new }
    subject { example.remove_references! object }

    describe 'hash' do
      let(:example) {
        {
          :foo => [
            object
          ],
          :a => [
            :b => {
              :c => [object],
              :d => [:a => {:b => object}]
            }, 
            :c => {}
          ]
        }
      }

      it { should eq(:foo => [], :a => [
        :b => { :c => [], :d => [:a => {}] }, :c => {}
      ]) }
    end

    describe 'array' do
      let(:example) {
        [:a, :b => [object, {:id => [object]}]]
      }

      it { should eq([:a, :b => [{:id => []}]]) }
    end
  end
end
