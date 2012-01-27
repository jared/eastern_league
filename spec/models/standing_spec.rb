require 'spec_helper'

describe Standing do
  describe ".calculate_standings" do
    
    before(:each) do
      @season = Factory :season
    end
    
    describe "simple standing calculations" do
      before(:each) do
        @event_discipline = Factory :event_discipline, :event => Factory(:event, :season => @season)

        @third_place = Factory :score, :event_discipline => @event_discipline, :rank => 3, :score => 70.00, :points => 16, :season => @season
        @second_place = Factory :score, :event_discipline => @event_discipline, :rank => 2, :score => 75.00, :points => 22, :season => @season
        @first_place = Factory :score, :event_discipline => @event_discipline, :rank => 1, :score => 80.00, :points => 28, :season => @season
      end
      
      it "should rank the competitors by points" do
        Standing.calculate_standings(@season)
        results = @season.standings.where(:discipline_id => @event_discipline.discipline.id)
        results.sort_by(&:rank).map(&:competitor).should == [@first_place.competitor, @second_place.competitor, @third_place.competitor]
      end
    end
    
  end
end
