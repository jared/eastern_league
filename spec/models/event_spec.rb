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
end
