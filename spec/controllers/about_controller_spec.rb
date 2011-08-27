require 'spec_helper'

describe AboutController do

  describe "#index" do
    it "should be successful" do
      get :index
      response.should be_success
      response.should render_template('index')
    end
  end

  describe "#competitors" do
    it "should be successful" do
      get :competitors
      response.should be_success
      response.should render_template('competitors')
    end
  end

  describe "#organizers" do
    it "should be successful" do
      get :organizers
      response.should be_success
      response.should render_template('organizers')
    end
  end

  describe "#spectators" do
    it "should be successful" do
      get :spectators
      response.should be_success
      response.should render_template('spectators')
    end
  end

end
