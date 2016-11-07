require 'spec_helper'

describe Order do
  describe "after_create" do
    before(:each) do
      @order = FactoryGirl.build(:order)
      2.times { @order.line_items << LineItem.new(:amount => 12.50) }
    end

    it "should calculate the total amount" do
      @order.save
      expect(@order.reload.amount).to eq 25.00
    end

    it "should encrypt the payment info into a PayPal button" do
      crypto = double("Encrypted Data", :encrypted_data => "definitely_encrypted_data")
      allow(ElCrypto::EncryptedOrder).to receive_messages(new: crypto)
      @order.save
      expect(@order.reload.encrypted_data).to eq "definitely_encrypted_data"
    end

  end
end
