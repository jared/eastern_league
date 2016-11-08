require 'spec_helper'

describe Event do
  describe "validations" do
    describe "with invalid attributes" do
      before(:each) do
        @event = Event.new
      end
      
      it "should be invalid without a name" do
        expect(@event).not_to be_valid
      end
    end
    
    describe "with invalid start/end dates" do
      before(:each) do
        @event = Event.new(:start_date => Date.today, :end_date => Date.today.yesterday)
      end
      
      it "should be invalid if end date is earlier than start date" do
        expect(@event).not_to be_valid
      end      
    end    
  end

  describe ".most_recent" do

    describe "when this season has scores" do 
      before(:each) do
        @season      = FactoryGirl.create(:season)
        @old_event   = FactoryGirl.create(:event, season: @season)
        @newer_event = FactoryGirl.create(:event, season: @season)
        @old_event_discipline = FactoryGirl.create(:event_discipline, event: @old_event)
        @new_event_discipline = FactoryGirl.create(:event_discipline, event: @newer_event)
        2.times { FactoryGirl.create(:score, event_discipline: @old_event_discipline, season: @season) }
        @newest_score = FactoryGirl.create(:score, event_discipline: @new_event_discipline, season: @season)
      end

      it "should return the most recently-scored event" do
        expect(Season.current).to eq @season

        expect(Event.most_recent).to eq @newer_event
      end
    end

    describe "when this season is empty" do
      before(:each) do
        @last_season      = FactoryGirl.create(:season, current: false)
        @current_season   = FactoryGirl.create(:season)
        @old_event   = FactoryGirl.create(:event, season: @last_season)
        @newer_event = FactoryGirl.create(:event, season: @last_season)
        @old_event_discipline = FactoryGirl.create(:event_discipline, event: @old_event)
        @new_event_discipline = FactoryGirl.create(:event_discipline, event: @newer_event)
        2.times { FactoryGirl.create(:score, event_discipline: @old_event_discipline, season: @last_season) }
        @newest_score = FactoryGirl.create(:score, event_discipline: @new_event_discipline, season: @last_season)
      end

      it "should return the most recently-scored event from the last season" do
        expect(Season.current).to eq @current_season

        expect(Event.most_recent).to eq @newer_event
        expect(@newer_event.season).to eq @last_season
      end
    end
  end

  describe "#event_dates" do
    before(:each) do
      @event = FactoryGirl.create :event
    end

    describe "when start and end date are in the same month" do
      it "should display the month just once" do
        expect(@event.event_dates).to eq "Aug  5- 6 2011"
      end
    end

    describe "when start and end date span two months" do
      before(:each) do
        @event.end_date = @event.end_date.advance(months: 1)
      end

      it "should display each month" do
        expect(@event.event_dates).to eq "Aug  5-Sep  6 2011"
      end

    end
  end
end
