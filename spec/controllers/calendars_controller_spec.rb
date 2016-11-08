require 'spec_helper'

RSpec.describe CalendarsController, type: :controller do 

  describe "#show" do
    before(:each) do
      (2010..2017).each { |year| FactoryGirl.create(:season, year: year)}
      get :show
    end

    it "should fetch the five most recent seasons" do
      expect(assigns(:seasons).size).to eq 5
    end 

    it "should start with the most recent season" do
      expect(assigns(:seasons).first.year).to eq "2017"
    end

    it "should conclude with the fifth-latest sesason" do
      expect(assigns(:seasons).last.year).to eq "2013"
    end
  end

end
