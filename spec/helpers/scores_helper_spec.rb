require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ScoresHelper. For example:
#
# describe ScoresHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
RSpec.describe ScoresHelper, type: :helper do
  describe "#score_name_and_link" do
    describe "for an individual competitor" do
      before(:each) do
        @user = FactoryGirl.create :active_user
        @competitor = FactoryGirl.create :competitor, user: @user
        @score = FactoryGirl.create :score, competitor: @competitor
      end

      it "should display the pair name" do
        expect(helper.score_name_and_link(@score)).to match /#{@user.full_name}/
      end

      it "should be a link to the competitor's bio" do
        expect(helper.score_name_and_link(@score)).to match /href/
      end

    end

    describe "for a pair/team competitor" do
      before(:each) do
        @score = FactoryGirl.create(:score, competitor: FactoryGirl.create(:pair))
      end

      it "should display the pair name" do
        expect(helper.score_name_and_link(@score)).to eq "Dueling Sabers"
      end
    end
  end
end
