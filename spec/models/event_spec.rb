require 'spec_helper'

describe Event do
  describe "validations" do
    describe "with invalid attributes" do
      before(:each) do
        @event = Event.new
      end
      
      it "should be invalid without a name" do
        @event.should_not be_valid
        @event.should have(1).errors_on(:name)
      end
      
      it "should be invalid without a location" do
        @event.should_not be_valid
        @event.should have(1).errors_on(:location)
      end
      
      it "should be invalid without a season_id" do
        @event.should_not be_valid
        @event.should have(1).errors_on(:season_id)
      end
      
      it "should not have date-related errors if no dates are specified" do
        @event.should_not be_valid
        @event.should have(0).errors_on(:end_date)
      end
      
    end
    
    describe "with invalid start/end dates" do
      before(:each) do
        @event = Event.new(:start_date => Date.today, :end_date => Date.today.yesterday)
      end
      
      it "should be invalid if end date is earlier than start date" do
        @event.should_not be_valid
        @event.should have(1).errors_on(:end_date)
      end
      
    end
    
  end
end
