require './spec/spec_helper'

describe Plumbus::Driver do
  describe "#load" do
    _driver_name = 'plumbus_fake_driver'
    let(:driver_name) { _driver_name }
    let(:driver_module) { PlumbusFakeDriver }
    subject { Plumbus::Driver.load driver_name }

    context 'without driver in load path' do
      it "throws an exception" do
        expect { subject }.to raise_error /#{driver_name}.*installed/
      end
    end

    context 'with plumbus_fake_driver in load path' do
      include_context 'with plumbus_fake_driver gem in load path'

      it { should_not equal(nil) }

      context 'with symbolic name for driver' do
        let(:driver_name) { _driver_name.to_sym }
        it { should_not equal(nil) }
      end

      it "be recorded in the link table" do
        subject
        expect(Plumbus::Driver.link_table).to include(driver_name.to_sym => driver_module)
      end
    end
  end
end
