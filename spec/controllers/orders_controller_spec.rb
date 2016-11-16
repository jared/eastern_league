require 'spec_helper'

RSpec.describe OrdersController, type: :controller do 
  describe "#purchase" do
    before(:each) do
      FactoryGirl.create :admin_setting
      @user = FactoryGirl.create :active_user
      @order = FactoryGirl.create :order, user: @user
      login_as @user
    end

    it "should render the purchase template" do
      get :purchase, user_id: @user.id, id: @order.id
      expect(response).to render_template 'purchase'
    end
  end

  describe "#thank_you" do
    before(:each) do
      FactoryGirl.create :admin_setting
      @user = FactoryGirl.create :active_user
      @order = FactoryGirl.create :order, user: @user
      login_as @user
      get :thank_you, user_id: @user.id, id: @order.id
    end

    it "should notify the user their order is received" do
      expect(flash[:notice]).to eq "Your order has been received!"
    end

    it "should render the purchase template" do
      expect(response).to render_template 'thank_you'
    end
  end
end
