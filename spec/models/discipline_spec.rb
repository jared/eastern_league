require 'spec_helper'

RSpec.describe Discipline, type: :model do
  describe "validations" do
    describe "with invalid attributes" do
      before(:each) do
        @discipline = FactoryGirl.create(:discipline)
      end
      
      it "should be invalid without a name" do
        @discipline.name = ""
        expect(@discipline).to_not be_valid
      end

      it "should be invalid without an abbreviation" do
        @discipline.abbreviation = ""
        expect(@discipline).to_not be_valid
      end
    end
  end
end
