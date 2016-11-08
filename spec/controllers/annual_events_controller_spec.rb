require 'spec_helper'

RSpec.describe AnnualEventsController, type: :controller do

  describe "#index" do
    it "should get a list of annual events" do
      FactoryGirl.create :annual_event 
      get :index
      expect(response).to be_success
      expect(response).to render_template('index')
      expect(assigns(:annual_events).size).to eq 1
    end
  end

end
