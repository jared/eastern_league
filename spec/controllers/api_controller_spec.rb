require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe ApiController do
  describe "#ipn" do
    before(:each) do
      ipn_setup_order
      @membership.stub!(:activate!).and_return(true)
    end

    describe "successful" do
      before(:each) do
        @ipn_params.merge!(:acknowledge => "true")
        mock_notify(@ipn_params)
      end

      it "should process an update the order state" do
        post :ipn, @ipn_params
        @order.reload.state.should == "IPN Received"
      end

      it "should set the paypal_status" do
        post :ipn, @ipn_params
        @order.reload.paypal_status.should == "Completed"
      end

      it "should set the transaction identifier" do
        post :ipn, @ipn_params
        @order.reload.paypal_transaction_identifier.should == @trans_id
      end

      it "should activate the membership" do
        post :ipn, @ipn_params
        @user.reload.el_member.should be_true
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
  @notify = mock(:transaction_id  => ipn[:txn_id],
                 :complete?       => true,
                 :status          => ipn[:payment_status],
                 :fee             => ipn[:payment_fee],
                 :invoice         => ipn[:invoice],
                 :acknowledge     => ipn[:acknowledge])
  Paypal::Notification.stub!(:new).and_return(@notify)
end
