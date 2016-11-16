require 'spec_helper'

RSpec.describe AdminSettingsController, type: :controller do
  shared_examples_for "a non-admin user" do
    before(:each) do
      login_as FactoryGirl.create(:active_user)
      get @action
    end

    it "should redirect the user away" do
      expect(response).to redirect_to root_path
    end

    it "should tell the user he doesn't have access" do
      expect(flash[:error]).to eq "You do not have permission to #{@action.to_s} this admin setting."
    end
  end

  describe "#edit" do
    describe "as a non-admin" do
      before(:each) do
        @action = :edit
      end
      it_should_behave_like "a non-admin user"
    end

    describe "as an admin" do
      before(:each) do
        login_as FactoryGirl.create(:admin_user)
        get :edit
      end

      it "should be a success" do
        expect(response).to be_success
      end

      it "should render the edit template" do
        expect(response).to render_template 'edit'
      end

      it "should load the admin settings object" do
        expect(assigns(:admin_setting)).to eq @admin_setting
      end


    end
  end

  describe "#update" do
    describe "as a non-admin" do
      before(:each) do
        @action = :update
      end
      it_should_behave_like "a non-admin user"
    end

    describe "as an admin" do
      before(:each) do
        login_as FactoryGirl.create(:admin_user)
        @new_commissioner = FactoryGirl.create :active_user
      end

      describe "with valid settings" do
        before(:each) do
          put :update, admin_setting: { commissioner_user_id: @new_commissioner.id }
        end

        it "should save changes" do          
          expect(assigns(:admin_setting).commissioner_user_id).to eq @new_commissioner.id
        end

        it "should notify the user of the save" do
          expect(flash[:notice]).to eq "Settings have been updated."
        end

        it "should redirect to root" do
          expect(response).to redirect_to root_path
        end
      end

      describe "with invalid settings" do
        it "should redirect to root" do
          put :update, admin_setting: { commissioner_user_id: nil }
          expect(response).to render_template 'edit'
        end

      end
    end

  end

end
