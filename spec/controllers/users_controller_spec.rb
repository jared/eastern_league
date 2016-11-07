require 'spec_helper'

RSpec.describe UsersController, type: :controller do 

  describe "#show" do
    before(:each) do
      @user = FactoryGirl.create :active_user
    end
    it "should show a user's profile page" do
      get :show, :id => @user.id
      expect(response).to be_success
    end

  end

  describe "#new" do
    it "should not require login" do
      get :new
      expect(response).to be_success
    end

    it "should use the new user template form" do
      get :new
      expect(response).to render_template 'new'
    end
  end

  describe "#create" do
    before(:each) do
      @params = { user: {street_addres_1: '123 Fake Street'} }
    end

    describe "with valid parameters" do
      before(:each) do
        @params[:user] = { :full_name => "Test User", :email => "test@example.com", :password => "password1!"}
      end

      it "should create a user" do
        expect do
          post :create, @params
        end.to change(User, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, @params
        expect(response).to redirect_to root_path
      end


    end

    describe "without valid parameters" do
      it "should not create a user" do
        expect do
          post :create, @params
        end.not_to change(User, :count)
      end

      it "should redisplay the new user form" do
        post :create, @params
        expect(response).to render_template 'new'
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
          expect(response).to render_template 'edit'
        end
      end

      describe "editing someone else's profile" do
        it "should not allow non-admin to edit" do
          @other_user = FactoryGirl.create(:user)
          get :edit, :id => @other_user.id
          expect(flash[:error]).to eq "You may only edit your own account."
          expect(response).to redirect_to root_path
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
        expect(response).to be_success
        expect(response).to render_template 'edit'
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
            expect(assigns(:user)).to be_valid
            expect(assigns(:user).full_name).to eq "Test Updated"
          end
        end

        describe "with invalid attributes" do
          it "should not update the user" do
            put :update, :id => @user.id, :user => { :email => "" }
            expect(assigns(:user)).not_to be_valid
            expect(response).to render_template 'edit'
          end

        end
      end

      describe "editing someone else's profile" do
        it "should not allow non-admin to edit" do
          @other_user = FactoryGirl.create(:user)
          put :update, :id => @other_user.id, :user => { :full_name => "Test Updated" }
          expect(flash[:error]).to eq "You may only edit your own account."
          expect(response).to redirect_to root_path
        end
      end
    end
  end


end
