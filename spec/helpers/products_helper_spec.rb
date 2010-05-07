require File.dirname(__FILE__) + '/../spec_helper'

describe ProductsHelper do
  include ProductsHelper
  before(:each) do
      Spree::Config.set(:show_zero_stock_products => false) 
      @product = Factory(:product) 
      @size_option_type = Factory(:option_type)
      @color_option_type = Factory(:option_type, 
                                   :name => 'foo-color', 
                                   :presentation => 'Color')
      ProductOptionType.create!(:product => @product, :option_type => @size_option_type)
      ProductOptionType.create!(:product => @product, :option_type => @color_option_type)
      colors = ['Red', 'Blue', 'Green']
      sizes = ['Small', 'Medium', 'Large']
      create_option_value_variables(colors, @color_option_type)
      create_option_value_variables(sizes, @size_option_type)
      colors.each do |color|
        sizes.each do |size|
          size_var = self.instance_variable_get("@#{size.downcase}_option_value")
          color_var = self.instance_variable_get("@#{color.downcase}_option_value")
          self.instance_variable_set("@#{size.downcase}_#{color.downcase}_variant", create_variant([size_var, color_var]))
        end
      end
      @small_red_variant = create_variant([@red_option_value, @small_option_value])                             
  end
  
  def create_option_value_variables(options, option_type)
      options.each do |option|
        self.instance_variable_set("@#{option.downcase}_option_value", create_option_value(option, option_type))
      end
  end
  
  def create_option_value(name, option_type)
    Factory(:option_value, 
            :name => name, 
            :presentation => name, 
            :option_type => option_type)
  end
  
  def create_variant(option_values = [])
      variant = Factory(:variant, :count_on_hand=> 10)
      @product.variants << variant
      variant.option_values.destroy_all
      option_values.each{|option_value| variant.option_values << option_value}
      variant
  end
  
  it 'should return size option values if size option type pass in' do
    expected = [@small_option_value, @medium_option_value, @large_option_value]
    instock_option_values(@product, @size_option_type).should == expected
  end
  
  it 'should not return option values for which there is no stock for all variants with that option value' do
    [@medium_red_variant, @medium_blue_variant, @medium_green_variant].each do |variant|
      variant.count_on_hand = 0
      variant.save!
    end
    expected = [@small_option_value, @large_option_value]
    instock_option_values(@product, @size_option_type).should == expected
  end
  
  it 'should return option values for no stock variants when Spree::Config[:show_zero_stock_products] is true' do
    Spree::Config.set(:show_zero_stock_products => true) 
    [@medium_red_variant, @medium_blue_variant, @medium_green_variant].each do |variant|
      variant.count_on_hand = 0
      variant.save!
    end
    expected = [@small_option_value, @medium_option_value, @large_option_value]
    instock_option_values(@product, @size_option_type).should == expected
  end
  
end