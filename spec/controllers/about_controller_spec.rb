require 'spec_helper'

RSpec.describe AboutController, type: :controller do

  describe "#index" do
    it "should be successful" do
      get :index
      expect(response).to be_success
      expect(response).to render_template('index')
    end
  end

  describe "#competitors" do
    it "should be successful" do
      get :competitors
      expect(response).to be_success
      expect(response).to render_template('competitors')
    end
  end

  describe "#organizers" do
    it "should be successful" do
      get :organizers
      expect(response).to be_success
      expect(response).to render_template('organizers')
    end
  end

  describe "#spectators" do
    it "should be successful" do
      get :spectators
      expect(response).to be_success
      expect(response).to render_template('spectators')
    end
  end

end
