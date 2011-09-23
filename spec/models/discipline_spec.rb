require 'spec_helper'

describe Discipline do
  describe "validations" do
    describe "with invalid attributes" do
      before(:each) do
        @discipline = Discipline.new
      end
      
      it "should be invalid without a name" do
        @discipline.should_not be_valid
        @discipline.should have(1).errors_on(:name)
      end

      it "should be invalid without an abbreviation" do
        @discipline.should_not be_valid
        @discipline.should have(1).errors_on(:abbreviation)
      end
    end
  end
end
