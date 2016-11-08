require 'spec_helper'

RSpec.describe UsersController, type: :controller do 

  describe "#index" do
    before(:each) do
      2.times { FactoryGirl.create :active_user }
    end

    describe "when logged in" do
      before(:each) do
        login_as(FactoryGirl.create(:active_user))
      end

      it "should prohibit access for non-admin users" do
        get :index
        expect(response).to be_redirect
        expect(flash[:error]).to eq "Only an administrator may view the list of users"
      end

      describe "as an admin" do
        before(:each) do
          @admin = FactoryGirl.create(:user, admin: true)
          login_as(@admin)
        end

        it "should show a list of users" do
          get :index
          expect(response).to be_success
          expect(response).to render_template 'index'
        end
      end
    end
  end

  describe "#show" do
    before(:each) do
      @user = FactoryGirl.create :active_user
    end
    it "should show a user's profile page" do
      get :show, :id => @user.id
      expect(response).to be_success
    end
  end

  describe "#search" do
    describe "with a valid Eastern League membership" do
      before(:each) do
        @user = FactoryGirl.create(:active_user, full_name: "Joe User")
        login_as(@user)
      end

      it "should perform a search with a 'q' parameter" do
        get :search, q: 'User'
        expect(assigns(:users)).to eq [@user]
      end

      it "should perform a search with a 'term' parameter" do
        get :search, term: 'User'
        expect(assigns(:users)).to eq [@user]
      end

      it "should return the JSON approximation of a user for autocomplete" do
        get :search, q: 'User', format: :json
        expect(response.body).to eq "[{\"id\":#{@user.id},\"label\":\"Joe User\",\"competitor_id\":#{@user.competitor.id}}]"
      end

    end

    describe "without a valid Eastern League membership" do
      before(:each) do
        login_as(FactoryGirl.create(:non_member))
        get :search, q: 'User'
      end

      it "should redirect away from search" do        
        expect(response).to be_redirect
      end

      it "should notify the user why he cannot search" do
        expect(flash[:error]).to eq "Only current Eastern League members may use the search function."
      end

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
    describe "as an average joe" do
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

    describe "as an admin" do
      before(:each) do
        @params = { user: {street_addres_1: '123 Fake Street'} }
        login_as(FactoryGirl.create(:admin_user))
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

        it "should redirect to the memberships page" do
          post :create, @params
          expect(response).to redirect_to new_user_membership_path(assigns(:user))
        end

        it "should notify the admin what to do next" do
          post :create, @params
          expect(flash[:notice]).to include "Now, you can set up the new user's first year of membership."
        end
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
        @admin = FactoryGirl.create(:admin_user)
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
        competitor = FactoryGirl.create :competitor
        @user = competitor.user
        login_as(@user)
      end

      describe "editing his own profile" do
        describe "with valid attributes" do
          it "should update the user" do
            put :update, id: @user.id, user: { full_name: "Test Updated" }
            expect(assigns(:user)).to be_valid
            expect(assigns(:user).full_name).to eq "Test Updated"
          end

          it "should remove the avatar if the user wishes" do
            expect(@user.competitor.avatar).to be_present
            put :update, id: @user.id, user: { full_name: "Test Updated" }, remove_avatar: true
            expect(assigns(:user)).to be_valid
            expect(assigns(:user).competitor.avatar).not_to be_present
          end
        end

        describe "with invalid attributes" do
          it "should not update the user" do
            put :update, id: @user.id, user: { email: "" }
            expect(assigns(:user)).not_to be_valid
            expect(response).to render_template 'edit'
          end

        end
      end

      describe "editing someone else's profile" do
        it "should not allow non-admin to edit" do
          @other_user = FactoryGirl.create(:user)
          put :update, id: @other_user.id, user: { full_name: "Test Updated" }
          expect(flash[:error]).to eq "You may only edit your own account."
          expect(response).to redirect_to root_path
        end
      end
    end
  end


end
