require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Order do

  it "should extend rather than modify order by calling the original add_variant through alias method" do
    Spree::Config.set(:allow_back_orders => false)
    o = Order.new
    v = mock(:in_stock? => true)
    o.should_receive(:add_variant_original)
    o.add_variant(v)
  end

  describe "add variant that doesn't exist or is not in stock" do
    before(:each) do
      Spree::Config.set(:allow_back_orders => false)
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

      describe "with back orders allowed" do
        before(:each) do
          Spree::Config.set(:allow_back_orders => true)
        end
        
        it 'should be valid' do
          @o.valid?.should be_true
        end
        
      end
    end
  end
end
