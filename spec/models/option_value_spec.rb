require File.dirname(__FILE__) + '/../spec_helper.rb'

describe OptionValue do
  
  it 'should have a display?' do
    o = OptionValue.new
    o.should respond_to(:display?)
  end
  
  describe 'display?' do
    it 'should be false if all variants are not instock' do
      v = Factory(:variant)
      ov = OptionValue.new
      v.option_values << ov
      ov.display?.should be_false
    end
    
    it 'should be true if one of its variants is instock' do
      v = Factory(:variant, :on_hand => 1)
      ov = v.option_values.first
      ov.display?.should be_true
    end
   
  end
end