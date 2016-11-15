require 'spec_helper'

include OffsitePayments::Integrations

RSpec.describe ApiController, type: :controller do
  describe "#ipn" do

    shared_examples_for "a successful order" do
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
    end

    describe "when the order is for a membership" do
      before(:each) do
        FactoryGirl.create(:admin_setting)
        ipn_setup_order
        allow(@membership).to receive_messages(activate!: true)      
      end

      describe "successful" do
        before(:each) do
          @ipn_params.merge!(:acknowledge => "true")
          mock_notify(@ipn_params)
        end

        it_should_behave_like "a successful order"
        
        describe "when the order is for a membership" do
          it "should activate the membership" do
            post :ipn, @ipn_params
            expect(@user.reload.el_member).to be true
          end
        end
      end
    end

    describe "when the order is for an event registration" do
      before(:each) do
        FactoryGirl.create :admin_setting
        @event_registration = FactoryGirl.create :event_registration
        ipn_setup_order(@event_registration)
        @ipn_params.merge!(:acknowledge => "true")
        mock_notify(@ipn_params)
      end

      it_should_behave_like "a successful order"

      it "should mark the registration as paid" do
        post :ipn, @ipn_params.merge(acknowledge: true)
        expect(assigns(:order).line_items.first.purchasable).to eq @event_registration
        expect(@event_registration.reload.paid).to be true
      end
    end

    describe "when the order is for a totally unpurchasable object" do
      before(:each) do
        FactoryGirl.create :admin_setting
        @user = FactoryGirl.create :user
        ipn_setup_order(@user)
        @ipn_params.merge!(:acknowledge => "true")
        mock_notify(@ipn_params)
      end

      it "should log the warning" do
        expect(Rails.logger).to receive(:warn).with("I don't know what to do with this line item #{@order.line_items.first.id}")
        post :ipn, @ipn_params
      end

    end


    describe "when an IPN matches an already-paid order" do
      before(:each) do
        ipn_setup_order
        @ipn_params.merge!(acknowledge: "true")
        @order.update_attribute(:paypal_transaction_identifier, @trans_id)
        mock_notify(@ipn_params)
      end

      it "should log the duplicate" do
        expect(Rails.logger).to receive(:warn).with("Multiple Payments received for #{@trans_id}")
        post :ipn, @ipn_params
      end
    end

    describe "when no order matches the IPN" do
      before(:each) do
        ipn_setup_order
        @ipn_params.merge!(acknowledge: "true", invoice: nil)
        mock_notify(@ipn_params)
      end

      it "should log the IPN as 'no-order-found'" do
        @file = double("File")
        allow(File).to receive(:open).and_yield(@file)
        expect(@file).to receive(:write).with("#{Time.now.to_s(:db)}: #{request.raw_post}\n")
        expect(@file).to receive(:write).with("#{Time.now.to_s(:db)}: No order found for #{@notify.inspect}")

        post :ipn, @ipn_params
      end

      it "should send mail to the admin about the unmatched money" do
        @mailer = double("UserMailer", deliver_now: true)
        expect(UserMailer).to receive(:user_message).and_return(@mailer)
        post :ipn, @ipn_params
      end

      it "should render nothing" do
        post :ipn, @ipn_params
        expect(response.body).to eq ""
      end
    end
  
    describe "when the paypal process is incomplete" do
      before(:each) do 
        ipn_setup_order
        @ipn_params.merge!(acknowledge: "true")
        mock_notify(@ipn_params, false, "incomplete")
      end

      it "should update the order setatus" do
        post :ipn, @ipn_params
        expect(assigns(:order).paypal_status).to eq "incomplete"
      end

      it "should log the warning" do
        expect(Rails.logger).to receive(:warn).with("#{@notify.transaction_id} was not complete.")
        post :ipn, @ipn_params
      end

      it "should mail the admin about the problem" do
        @mailer = double("UserMailer", deliver_now: true)
        expect(UserMailer).to receive(:user_message).and_return(@mailer)
        post :ipn, @ipn_params
      end

      it "should render nothing" do
        post :ipn, @ipn_params
        expect(response.body).to eq ""
      end
    end

    describe "when the notify is unacknowledged" do
      before(:each) do
        FactoryGirl.create(:admin_setting)
        ipn_setup_order
        allow(@membership).to receive_messages(activate!: true)
        @ipn_params.merge!(acknowledge: false)
        mock_notify(@ipn_params, false, "Conflicted")
      end

      it "should set the order to 'conflicted'" do
        expect { 
          post :ipn, @ipn_params 
          expect(assigns(:order)).to receive(:update_attributes).with(state: "Conflicted", paypal_status: "Conflicted")
        }.to raise_error RuntimeError


      end

      it "should log the problem" do
        expect(Rails.logger).to receive(:warn).with("#{@notify.transaction_id} was not acknowledged.")
        expect { post :ipn, @ipn_params }.to raise_error RuntimeError
      end

      it "should raise an exception" do
        expect { post :ipn, @ipn_params }.to raise_error RuntimeError
      end
    end
  end
end

def ipn_setup_order(purchasable=nil)
  @user = FactoryGirl.create :user
  @order = FactoryGirl.build(:order)
  if purchasable.present?
    @order.line_items << LineItem.new(purchasable: purchasable, amount: 15.00)
    @item_name = "Custom Purchasable"
  else
    @membership = FactoryGirl.create :membership, user: @user
    @order.line_items << LineItem.new(purchasable: @membership, amount: 15.00)
    @item_name = @membership.membership_plan.name
  end
  @order.save

  @trans_id = "16F08736TA389152H"
  @ipn_params = {:payment_date => "04:33:33 Oct 13.2007+PDT" ,
       :txn_type => "web_accept",
       :last_name => "User",
       :residence_country => "US",
       :item_name => @item_name,
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

def mock_notify(ipn, complete=true, status=nil)
  @notify = double("Paypal Notification", transaction_id: ipn[:txn_id],
                 complete?: complete,
                 status: status || ipn[:payment_status],
                 fee: ipn[:payment_fee],
                 invoice: ipn[:invoice],
                 acknowledge: ipn[:acknowledge])
  allow(Paypal::Notification).to receive_messages(new: @notify)
end
