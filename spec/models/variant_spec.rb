require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Variant do
  describe 'find variants by option type values and product' do
    before(:each) do
      @product = Factory(:product)
      @variant = Factory(:variant, :product_id => @product.id)
      @variant.option_values.destroy_all
      # @size_option_type = Factory(:option_type)
      # @color_option_type = Factory(:option_type, :name => 'foo-color', :presentation => 'Color')
      @red_option_value = Factory(:option_value, :name => 'Red', :presentation => 'Red')
      @size_option_value = Factory(:option_value, :name => 'Small', :presentation => 'Small')
      @variant.option_values << @red_option_value
      @variant.option_values << @size_option_value
      @variant.reload.option_values.count.should == 2
    end
    
    it 'should have a class method for doing this type of find' do
      Variant.should respond_to(:find_by_option_types_and_product)
    end
    
    it 'should find the variant' do
      option_types = {"1" => @red_option_value.id, "2" => @size_option_value.id}
      Variant.find_by_option_types_and_product(option_types, @product.id).should == @variant
    end
    
  end
end

