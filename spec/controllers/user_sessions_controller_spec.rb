require 'spec_helper'

RSpec.describe UserSessionsController, type: :controller do 

  describe "#new" do
    it "should be successful" do
      get :new
      expect(response).to be_success
      expect(response).to render_template('new')
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
        @params[:user_session][:password] = 'password1!'
      end

      it "should set the current user" do
        post :create, @params
        user_session = UserSession.find
        expect(user_session.user).to eq @user
      end

      it "should log the user in" do
        post :create, @params
        expect(flash[:notice]).to eq "Login successful!"
        expect(response).to redirect_to(user_path(@user))
      end
    end

    describe "with invalid user credentials" do
      before(:each) do
        @params[:user_session][:email] = "nobody@example.com"
        @params[:user_session][:password] = 'totallyfakepassword!'
      end

      it "should display an error" do
        post :create, @params
        expect(flash[:error]).to eq "Login failed. Please check your email address and password, then try again."
      end

      it "should redisplaly the login form" do
        post :create, @params
        expect(response).to render_template 'new'
      end
    end
  end

  describe "#destroy" do
    before(:each) do
      login_as FactoryGirl.create(:user)
    end

    it "should log out the current user" do
      delete :destroy
      expect(flash[:notice]).to eq "Logout successful!"
    end

    it "should redirect to the login page" do
      delete :destroy
      expect(response).to redirect_to login_path
    end

  end


end
