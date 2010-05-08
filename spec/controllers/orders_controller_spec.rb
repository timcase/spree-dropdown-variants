require File.dirname(__FILE__) + '/../spec_helper'

describe OrdersController do
  
  before(:each) do
    Spree::Config.set(:allow_backorders => false)
    @product = Factory(:product)
    create_in_stock_variant
    @size_option_type = Factory(:option_type)
    @color_option_type = Factory(:option_type, :name => 'foo-color', :presentation => 'Color')
  end
  
  def create_in_stock_variant
    create_variant
  end
  
  def create_out_of_stock_variant
    create_variant(0)
  end
  
  def create_variant(stock = 15)
    @variant = Factory(:variant, :product_id => @product.id, :on_hand=> stock)
    @variant.option_values.destroy_all
    @red_option_value = Factory(:option_value, :name => 'Red', :presentation => 'Red')
    @size_option_value = Factory(:option_value, :name => 'Small', :presentation => 'Small')
    @variant.option_values << @red_option_value
    @variant.option_values << @size_option_value
  end
  
  def do_create
    post :create, :quantity => 1, :product => @product.id, 
         :option_types => {@size_option_type.id => @size_option_value.id, 
                           @color_option_type.id => @red_option_value.id}
  end
  
  it 'should redirect on success' do
     do_create
     response.should be_redirect
  end
  
  it 'should return success when variant is invalid' do
    create_out_of_stock_variant
    do_create
    response.should be_success
  end
  
  it 'should render the products show template' do
    create_out_of_stock_variant
    do_create
    response.should render_template('orders/edit')
  end

end



