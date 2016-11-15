require 'spec_helper'

RSpec.describe Score, type: :model do

  describe ".calculate_points" do
    before(:each) do
      @event_discipline = FactoryGirl.create(:event_discipline)
      
    end

    describe "for an individual-flyer discipline" do
      describe "with more than 10 flyers" do
        before(:each) do
          1.upto(15) { |i| FactoryGirl.create(:score, event_discipline: @event_discipline, rank: i) }
        end
        it "should only assign points to the top 10 ranks" do
          Score.calculate_points(@event_discipline, false)
          10.upto(14).each { |i| expect(@event_discipline.scores.ranked[i].points).to eq 0 }
        end
      end

      describe "with a reasonable number of flyers" do
        before(:each) do
          1.upto(5) { |i| FactoryGirl.create(:score, event_discipline: @event_discipline, rank: i) }
        end

        it "should not assign points to an expired member" do
          @event_discipline.scores.ranked[1].competitor.user.update_attribute(:el_member, false)
          Score.calculate_points(@event_discipline, false)
          expect(@event_discipline.scores.ranked[1].points).to eq 0
          expect(@event_discipline.scores.ranked[1].current_member).to be false
        end

        it "should not assign points to a disqualified flyer" do
          @event_discipline.scores.ranked.last.update_attributes(disqualified: true)
          Score.calculate_points(@event_discipline, false)
          expect(@event_discipline.scores.ranked.last.points).to eq 0
        end

        it "should assign bonus points based on the number of flyers in the discipline" do
          Score.calculate_points(@event_discipline, false)
          { 1 => 30, 2 => 24, 3 => 18, 4 => 14, 5 => 11}.each do |rank, points|
            expect(@event_discipline.scores.ranked[rank-1].points).to eq points
          end
        end
      end
    end

    describe "for a pair/team discipline" do
      before(:each) do
        1.upto(5) { |i| FactoryGirl.create(:score, event_discipline: @event_discipline, rank: i) }
      end

      it "should assign bonus points based on the number of flyers in the discipline" do
        Score.calculate_points(@event_discipline, true)
        { 1 => 35, 2 => 28, 3 => 21, 4 => 16, 5 => 12}.each do |rank, points|
          expect(@event_discipline.scores.ranked[rank-1].points).to eq points
        end
      end
    end
  end
end
