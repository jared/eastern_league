require 'spec_helper'

describe Season do
  describe ".current" do
    before(:each) do
      @current_season = FactoryGirl.create :season
      2.times { |i| FactoryGirl.create :season, :current => false, :year => i}
    end

    it "should return the current season" do
      Season.current.should == @current_season
    end
  end
end
