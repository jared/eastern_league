require 'spec_helper'

describe UserSessionsController do

  describe "#new" do
    it "should be successful" do
      get :new
      response.should be_success
      response.should render_template('new')
    end
  end

  describe "#create" do
    before(:each) do
      @params = { :user_session => {}}
    end

    describe "with valid user credentials" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @params[:user_session][:email] = @user.email
        @params[:user_session][:password] = 'test'
      end

      it "should set the current user" do
        post :create, @params
        user_session = UserSession.find
        user_session.user.should == @user
      end

      it "should log the user in" do
        post :create, @params
        flash[:notice].should == "Login successful!"
        response.should redirect_to(user_path(@user))
      end
    end

    describe "with invalid user credentials" do
      it "should display an error" do
        post :create, @params
        flash[:error].should == "Login failed. Please check your email address and password, then try again."
      end

      it "should redisplaly the login form" do
        post :create, @params
        response.should render_template 'new'
      end
    end
  end

  describe "#destroy" do
    before(:each) do
      login_as FactoryGirl.create(:user)
    end

    it "should log out the current user" do
      delete :destroy
      flash[:notice].should == "Logout successful!"
    end

    it "should redirect to the login page" do
      delete :destroy
      response.should redirect_to login_path
    end

  end


end
