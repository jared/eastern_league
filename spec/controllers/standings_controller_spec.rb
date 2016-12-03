require 'spec_helper'

RSpec.describe StandingsController, type: :controller do 

  shared_examples_for "a non-admin user" do
    before(:each) do
      login_as FactoryGirl.create(:active_user)
      send @method, @action, @params
    end

    it "should redirect the user away" do
      expect(response).to redirect_to root_path
    end

    it "should tell the user he doesn't have access" do
      expect(flash[:error]).to match /Only admin users can calculate standings/i
    end
  end

  describe "GET index" do
    before(:each) do
      @season = FactoryGirl.create(:season, current: true)
    end
    describe "without a season_id" do
      it "should load standings for the current season" do
        get :index
        expect(assigns(:season)).to eq @season
      end

      it "should be a success" do
        get :index
        expect(response).to be_success
      end

      it "should render the index template" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "with a season_id" do
      before(:each) do
        @past_season = FactoryGirl.create(:season, year: '2015', current: false)
      end

      it "should load standings for the season given" do
        get :index, season_id: @past_season.id
        expect(assigns(:season)).to eq @past_season
      end
    end
  end

  describe "POST calculate" do
    before(:each) { @method, @action, @params = :post, :calculate, {}}

    describe "for an admin user" do
      before(:each) do
        @season = FactoryGirl.create(:season, current: true)
        login_as FactoryGirl.create(:admin_user)
        @standing = double("Standing")
        expect(Standing).to receive(:calculate_standings).with(@season).and_return(@standing)
        post :calculate
      end

      it "should notify the user that the standings were updated" do
        expect(flash[:notice]).to eq "Standings have been updated for this season."
      end

      it "should redirect to the standings index" do
        expect(response).to redirect_to standings_path
      end

    end

    it_should_behave_like "a non-admin user"
  end

  describe "POST calculate_final" do
    before(:each) { @method, @action, @params = :post, :calculate_final, {}}

    describe "for an admin user" do
      before(:each) do
        @season = FactoryGirl.create(:season, current: true)
        login_as FactoryGirl.create(:admin_user)
        @standing = double("Standing")
        expect(Standing).to receive(:calculate_standings).with(@season, true).and_return(@standing)
        post :calculate_final
      end

      it "should notify the user that the standings were updated" do
        expect(flash[:notice]).to eq "Final standings have been updated for this season."
      end

      it "should redirect to the standings index" do
        expect(response).to redirect_to standings_path
      end

    end

    it_should_behave_like "a non-admin user"
  end

  

end
