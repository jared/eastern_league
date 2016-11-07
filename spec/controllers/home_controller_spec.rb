require 'spec_helper'

RSpec.describe HomeController, type: :controller do 

  describe "#index" do
    it "should be successful" do
      get :index
      expect(response).to be_success
      expect(response).to render_template('index')
    end
  end

end
