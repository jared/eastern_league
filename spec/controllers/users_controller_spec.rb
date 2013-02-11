require 'spec_helper'

describe UsersController do

  describe "#show" do
    before(:each) do
      @user = FactoryGirl.create :active_user
    end
    it "should show a user's profile page" do
      get :show, :id => @user.id
      response.should be_success
    end

  end

  describe "#new" do
    it "should not require login" do
      get :new
      response.should be_success
    end

    it "should use the new user template form" do
      get :new
      response.should render_template 'new'
    end
  end

  describe "#create" do
    before(:each) do
      @params = { :user => {}}
    end

    describe "with valid parameters" do
      before(:each) do
        @params[:user] = { :full_name => "Test User", :email => "test@example.com", :password => "test"}
      end

      it "should create a user" do
        lambda do
          post :create, @params
        end.should change(User, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, @params
        response.should redirect_to root_path
      end


    end

    describe "without valid parameters" do
      it "should not create a user" do
        lambda do
          post :create, @params
        end.should_not change(User, :count)
      end

      it "should redisplay the new user form" do
        post :create, @params
        response.should render_template 'new'
      end
    end
  end

  describe "#edit" do
    describe "as regular user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        login_as(@user)
      end

      describe "editing his own profile" do
        it "should render the edit form" do
          get :edit, :id => @user.id
          response.should render_template 'edit'
        end
      end

      describe "editing someone else's profile" do
        it "should not allow non-admin to edit" do
          @other_user = FactoryGirl.create(:user)
          get :edit, :id => @other_user.id
          flash[:error].should == "You may only edit your own account."
          response.should redirect_to root_path
        end
      end
    end

    describe "as admin user" do
      before(:each) do
        @admin = FactoryGirl.create(:user, :admin => true)
        @user = FactoryGirl.create(:user)
        login_as(@admin)
      end

      it "should allow admin to edit other user profiles" do
        get :edit, :id => @user.id
        response.should be_success
        response.should render_template 'edit'
      end
    end
  end

  describe "#update" do
    describe "as regular user" do
      before(:each) do
        @user = FactoryGirl.create(:user)

        login_as(@user)
      end

      describe "editing his own profile" do
        describe "with valid attributes" do
          it "should update the user" do
            put :update, :id => @user.id, :user => { :full_name => "Test Updated" }
            assigns(:user).should be_valid
            assigns(:user).full_name.should == "Test Updated"
          end
        end

        describe "with invalid attributes" do
          it "should not update the user" do
            put :update, :id => @user.id, :user => { :email => "" }
            assigns(:user).should_not be_valid
            response.should render_template 'edit'
          end

        end
      end

      describe "editing someone else's profile" do
        it "should not allow non-admin to edit" do
          @other_user = FactoryGirl.create(:user)
          put :update, :id => @other_user.id, :user => { :full_name => "Test Updated" }
          flash[:error].should == "You may only edit your own account."
          response.should redirect_to root_path
        end
      end
    end
  end


end
