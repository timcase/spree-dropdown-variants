require File.dirname(__FILE__) + '/../spec_helper.rb'

describe OptionType do
  describe 'in stock option values' do
    before(:each) do
      @product = Factory(:product)
      @option_type = Factory(:option_type)
      @product_option_type = ProductOptionType.create(:product => @product, :option_type => @option_type)
      
    end
    
    it 'should return an array of option values' do
      # @option_type.
    end
    
  end
  
end