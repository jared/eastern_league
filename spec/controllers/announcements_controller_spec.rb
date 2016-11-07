require 'spec_helper'

RSpec.describe AnnouncementsController, type: :controller do

  shared_examples_for "a non-admin user" do
    it "should deny access" do
      send @method, @action, @params
      expect(response).to be_redirect
    end
  end

  context "GET actions" do

    context "show" do
      before(:each) do
        @announcement = FactoryGirl.create :announcement
      end

      it "should render the show template" do
        get :show, id: @announcement.id
        expect(response).to render_template :show
      end

      it "should instantiate the announcement object" do
        get :show, id: @announcement.id
        expect(assigns(:announcement)).to eq(@announcement)
      end

    end

    context "index" do
      before(:each) do
        2.times { FactoryGirl.create(:announcement) }
      end

      context "as an admin" do
        before(:each) do
          @admin = FactoryGirl.create(:user, admin: true)
          login_as(@admin)
        end

        it "should allow access" do
          get :index
          expect(response).to be_success
        end

        it "should grab the list of announcements" do
          get :index
          expect(assigns(:announcements)).not_to be_empty
        end
      end

    end

    context "GET new" do
      context "as an admin" do
        before(:each) do
          @admin = FactoryGirl.create(:user, admin: true)
          login_as(@admin)
        end

        it "render the new announcement form" do
          get :new
          expect(response).to render_template :new
        end

      end

      context "as a non-admin" do
        before(:each) do
          @method = :get
          @action = :new
          @params = {}
        end

        it_should_behave_like "a non-admin user"
      end

    end

    context "GET edit" do
      before(:each) do
        @announcement = FactoryGirl.create :announcement
      end

      context "as an admin" do
        before(:each) do
          @admin = FactoryGirl.create(:user, admin: true)
          login_as(@admin)
        end

        it "render the new announcement form" do
          get :edit, id: @announcement.id
          expect(response).to render_template :edit
        end

      end

      context "as a non-admin" do
        before(:each) do
          @method = :get
          @action = :edit
          @params = {id: @announcement.id}
        end

        it_should_behave_like "a non-admin user"
      end

    end

  end

  context "POST actions" do

    context "create" do
      context "for an admin user" do
        before :each do
          @admin = FactoryGirl.create :user, admin: true
          login_as @admin
        end
        context "with valid parameters" do
          before(:each) do
            @params = {announcement: { headline: "Some Text", body: "Some more text"}}
          end

          it "should create a new announcement" do
            expect { post(:create, @params) }.to change(Announcement, :count).by 1
          end

          it "should redirect to the index page" do
            post :create, @params
            expect(response).to redirect_to announcements_path
          end

        end

        context "with invalid parameters" do
          before(:each) do
            @params = {announcement: {headline: 'nobody'} }
          end

          it "should not create a new announcement" do
            expect { post(:create, @params) }.not_to change(Announcement, :count)
          end

          it "should re-render the new template" do
            post :create, @params
            expect(response).to render_template :new
          end

        end
      end

      context "for a non-admin" do
        before(:each) do
          @method = :post
          @action = :create
          @params = {announcement: { headline: "Some Text", body: "Some more text"}}
        end

        it_should_behave_like "a non-admin user"
      end
    end

  end

  context "PUT actions" do

    context "update" do
      context "for an admin user" do
        before :each do
          @announcement = FactoryGirl.create :announcement
          @admin = FactoryGirl.create :user, admin: true
          login_as @admin
        end
        context "with valid parameters" do
          before(:each) do
            @params = {id: @announcement.id, announcement: { headline: "Some Text", body: "Some more text"}}
          end

          it "should update an announcement" do
            put :update, @params
            expect(assigns(:announcement).headline).to eq("Some Text")
          end

          it "should redirect to the index page" do
            put :update, @params
            expect(response).to redirect_to announcements_path
          end

        end

        context "with invalid parameters" do
          before(:each) do
            @params = {id: @announcement.id, announcement: { body: nil }}
          end

          it "should re-render the new template" do
            put :update, @params
            expect(response).to render_template :edit
          end

        end
      end

      context "for a non-admin" do
        before(:each) do
          @announcement = FactoryGirl.create :announcement
          @method = :put
          @action = :update
          @params = {id: @announcement.id, announcement: { headline: "Some Text", body: "Some more text"}}
        end

        it_should_behave_like "a non-admin user"
      end
    end

  end

  context "DELETE actions" do

    context "destroy" do
      context "for an admin user" do
        before :each do
          @announcement = FactoryGirl.create :announcement
          @admin = FactoryGirl.create :user, admin: true
          login_as @admin
        end
        context "with valid parameters" do
          before(:each) do
            @params = {id: @announcement.id}
          end

          it "should delete an announcement" do
            expect {
              delete :destroy, @params
            }.to change(Announcement, :count).by(-1)
          end

          it "should redirect to the index page" do
            delete :destroy, @params
            expect(response).to redirect_to announcements_path
          end

        end

      end

      context "for a non-admin" do
        before(:each) do
          @method = :delete
          @action = :destroy
          @params = {id: FactoryGirl.create(:announcement).id}
        end

        it_should_behave_like "a non-admin user"
      end
    end

  end


end
