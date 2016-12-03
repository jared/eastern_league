require 'spec_helper'

RSpec.describe SeasonsController, type: :controller do

  shared_examples_for "a non-admin user" do
    before(:each) do
      login_as FactoryGirl.create(:active_user)
      send @method, @action, @params
    end

    it "should redirect the user away" do
      expect(response).to redirect_to root_path
    end

    it "should tell the user he doesn't have access" do
      expect(flash[:error]).to match /You do not have permission to (.*) this season/
    end
  end

  shared_examples_for "admin access with template" do
    it "should be a success" do
      expect(response).to be_success
    end

    it "should render the expected template" do
      expect(response).to render_template @action
    end
  end

  describe "GET index" do
    before(:each) { @method, @action, @params = :get, :index, {} }

    describe "as an admin user" do
      before(:each) do
        @season = FactoryGirl.create(:season)
        login_as FactoryGirl.create(:admin_user)
        send @method, @action, @params
      end

      it_should_behave_like "admin access with template"

      it "should populate the @seasons object" do
        expect(assigns(:seasons)).to eq [@season]
      end
    end

    describe "as a non-admin user" do
      it_should_behave_like "a non-admin user"
    end
  end

  describe "GET new" do
    before(:each) { @method, @action, @params = :get, :new, {} }
    
    describe "as an admin user" do
      before(:each) do
        login_as FactoryGirl.create(:admin_user)
        send @method, @action, @params
      end

      it_should_behave_like "admin access with template"
    end

    describe "as a non-admin user" do
      it_should_behave_like "a non-admin user"
    end
  end

  describe "GET edit" do
    before(:each) do 
      @season = FactoryGirl.create(:season)
      @method, @action, @params = :get, :edit, {id: @season.id} 
    end
    
    describe "as an admin user" do
      before(:each) do
        login_as FactoryGirl.create(:admin_user)
        send @method, @action, @params
      end

      it_should_behave_like "admin access with template"

      it "should populate the @season variable" do
        expect(assigns(:season)).to eq @season
      end
    end

    describe "as a non-admin user" do
      it_should_behave_like "a non-admin user"
    end
  end

  describe "POST create" do
    before(:each) { @method, @action, @params = :post, :create, {season: { year: '2017', start_date: '2016-01-01', end_date: '2016-12-31'} } }

    describe "as an admin user" do
      before(:each) do
        login_as FactoryGirl.create(:admin_user)
      end

      describe "with valid parameters" do
        it "should create a new season object" do
          expect { post :create, @params }.to change(Season, :count).by 1
        end

        it "should redirect to the index" do
          post :create, @params
          expect(response).to redirect_to seasons_path
        end
      end

      describe "with invalid parameters" do
        before(:each) do
          @params = { season: { year: '', start_date: '', end_date: '' } }
        end

        it "should not save the season object" do
          expect { post :create, @params }.not_to change(Season, :count)
        end

        it "should re-render the create template" do
          post :create, @params
          expect(response).to render_template :new
        end
      end
    end

    describe "as a non-admin user" do
      it_should_behave_like "a non-admin user"
    end

  end

  describe "PUT update" do
    before(:each) do
      @season = FactoryGirl.create :season, year: '2016'
      @method, @action, @params = :put, :update, {id: @season.id, season: { year: '2017', start_date: '2016-01-01', end_date: '2016-12-31'} } 
    end

    describe "as an admin user" do
      before(:each) do
        login_as FactoryGirl.create(:admin_user)
        put :update, @params
      end

      describe "with valid parameters" do
        it "should update the season object" do
          expect(assigns(:season).year).to eq '2017'
        end

        it "should redirect to the index" do
          expect(response).to redirect_to seasons_path
        end
      end

      describe "with invalid parameters" do
        before(:each) do
          @params = {id: @season.id, season: { year: '', start_date: '', end_date: '' } }
          put :update, @params
        end

        it "should not save the season object" do
          expect(assigns(:season)).not_to be_valid
        end

        it "should re-render the create template" do
          expect(response).to render_template :edit
        end
      end
    end

    describe "as a non-admin user" do
      it_should_behave_like "a non-admin user"
    end

  end



end
