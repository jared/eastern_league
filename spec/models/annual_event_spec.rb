require 'spec_helper'

RSpec.describe AnnualEvent, type: :model do
  describe "#annual_number" do
    it "should return the Xth annual year number" do
      @annual_event = AnnualEvent.create(event_name: "Holly Springs Kite Festival", start_year: 1.year.ago.year)
      expect(@annual_event.annual_number).to eq 2
    end
  end
end
