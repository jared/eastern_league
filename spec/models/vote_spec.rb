require 'spec_helper'

RSpec.describe Vote, type: :model do

  describe "before_create" do
    it "should require two candidates to be selected" do
      @vote = FactoryGirl.create :vote, candidate_ids: 2.times.map { FactoryGirl.create(:candidate).id }
      expect(@vote).to be_valid
    end

    it "should not allow only one candidate to be selected, except on the way to two" do
      @vote = FactoryGirl.build :vote, candidate_ids: [FactoryGirl.create(:candidate).id]
      expect(@vote).not_to be_valid
      expect(@vote.errors.messages).to include({base: ["Please choose (only) two candidates"]})
    end

    it "should not allow three candidates to be selected" do
      @vote = FactoryGirl.build :vote, candidate_ids: 3.times.map { FactoryGirl.create(:candidate).id }
      expect(@vote).not_to be_valid
      expect(@vote.errors.messages).to include({base: ["Please choose (only) two candidates"]})

    end
  end
  
end
