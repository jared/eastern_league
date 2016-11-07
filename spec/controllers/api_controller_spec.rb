require 'spec_helper'

include OffsitePayments::Integrations

RSpec.describe ApiController, type: :controller do
  describe "#ipn" do
    before(:each) do
      ipn_setup_order
      allow(@membership).to receive_messages(activate!: true)      
    end

    describe "successful" do
      before(:each) do
        @ipn_params.merge!(:acknowledge => "true")
        mock_notify(@ipn_params)
      end

      it "should process an update the order state" do
        post :ipn, @ipn_params
        expect(@order.reload.state).to eq "IPN Received"
      end

      it "should set the paypal_status" do
        post :ipn, @ipn_params
        expect(@order.reload.paypal_status).to eq "Completed"
      end

      it "should set the transaction identifier" do
        post :ipn, @ipn_params
        expect(@order.reload.paypal_transaction_identifier).to eq @trans_id
      end

      it "should activate the membership" do
        post :ipn, @ipn_params
        expect(@user.reload.el_member).to be true
      end

    end

  end
end

def ipn_setup_order
  @user = FactoryGirl.create :user
  @membership = FactoryGirl.create :membership, :user => @user
  @order = FactoryGirl.build(:order)
  @order.line_items << LineItem.new(:purchasable => @membership, :amount => 15.00)
  @order.save

  @trans_id = "16F08736TA389152H"
  @ipn_params = {:payment_date => "04:33:33 Oct 13.2007+PDT" ,
       :txn_type => "web_accept",
       :last_name => "User",
       :residence_country => "US",
       :item_name => @membership.membership_plan.name,
       :payment_gross => "15.00",
       :mc_currency => "USD",
       :business => PAYPAL_USER_ACCOUNT,
       :payment_type => "instant",
       :verify_sign => "AZQLcOZ7B.YM2m-QDAXOrQQcLFYuA0N0XoC3zadaGhkGNF2nlRWmpzlI",
       :payer_status => "verified",
       :test_ipn => "1",
       :tax => "0.00",
       :payer_email => "user@example.com",
       :txn_id => @trans_id,
       :quantity => "1",
       :receiver_email => PAYPAL_USER_ACCOUNT,
       :first_name => "Test",
       :invoice => @order.id,
       :payer_id =>  "LABE9FLLRP8Q8",
       :receiver_id => "NPNG6WWZ6YZMG",
       :item_number => "3",
       :payment_status => "Completed",
       :payment_fee => "1.00",
       :mc_fee => "1.00",
       :shipping => "0.00",
       :mc_gross => "15.00",
       :custom => "3",
       :charset => "windows-1252",
       :notify_version => "2.4"
     }
end

def mock_notify(ipn)
  @notify = double("Paypal Notification", transaction_id: ipn[:txn_id],
                 complete?: true,
                 status: ipn[:payment_status],
                 fee: ipn[:payment_fee],
                 invoice: ipn[:invoice],
                 acknowledge: ipn[:acknowledge])
  allow(Paypal::Notification).to receive_messages(new: @notify)
end
