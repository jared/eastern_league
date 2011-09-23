require 'spec_helper'

describe Order do
  describe "after_create" do
    before(:each) do
      @order = Factory.build(:order)
      2.times { @order.line_items << LineItem.new(:amount => 12.50) }
    end
    
    it "should calculate the total amount" do
      @order.save
      @order.reload.amount.should == 25.00
    end
    
    it "should encrypt the payment info into a PayPal button" do
      crypto = mock(:encrypted_data => "definitely_encrypted_data")
      ElCrypto::EncryptedOrder.should_receive(:new).and_return(crypto)
      @order.save
      @order.reload.encrypted_data.should == "definitely_encrypted_data"
    end
    
  end
end
