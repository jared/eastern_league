require 'spec_helper'

describe Season do
  describe ".current" do
    before(:each) do
      @current_season = Factory :season
      2.times { |i| Factory :season, :current => false, :year => i}
    end
    
    it "should return the current season" do
      Season.current.should == @current_season
    end
  end
end
