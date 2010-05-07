require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Order do

  it "should extend rather than modify order by calling the original add_variant through alias method" do
    o = Order.new
    v = mock(:in_stock? => true)
    o.should_receive(:add_variant_original)
    o.add_variant(v)
  end

  describe 'add variant with validation error' do
    before(:each) do
      @o = Order.new
      @v = stub('Variant', :in_stock? => false)
      @o.should_receive(:add_variant_original)
    end

    it 'should add a validation error is variant passed in is nil' do
      lambda {
        @o.add_variant(nil)
        @o.valid?
      }.should change(@o.errors, :size).by(1)
    end

    it 'should add a validation error if variant passed in is out of stock' do
      lambda {
        @o.add_variant(@v)
        @o.valid?
      }.should change(@o.errors, :size).by(1)
    end
    describe 'error handling' do
      before(:each) do
        @o.add_variant(@v)
        @o.valid?
      end
      
      it 'should add a message explaining that the variant is not available' do
        @o.errors.on_base.include?('The selection you made is not in stock.').should be_true
      end

      it 'should not be valid with errors' do
        @o.valid?.should be_false
      end
    end
  end
end
