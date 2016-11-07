require 'spec_helper'

RSpec.describe Standing, type: :model do
  describe ".calculate_standings" do

    before(:each) do
      @season = FactoryGirl.create :season
    end

    describe "simple standing calculations" do
      before(:each) do
        @event_discipline = FactoryGirl.create :event_discipline, event: FactoryGirl.create(:event, season: @season)

        @third_place  = FactoryGirl.create :score, event_discipline: @event_discipline, rank: 3, score: 70.00, points: 16, season: @season
        @second_place = FactoryGirl.create :score, event_discipline: @event_discipline, rank: 2, score: 75.00, points: 22, season: @season
        @first_place  = FactoryGirl.create :score, event_discipline: @event_discipline, rank: 1, score: 80.00, points: 28, season: @season
      end

      it "should rank the competitors by points" do
        Standing.calculate_standings(@season)
        results = @season.standings.where(discipline_id: @event_discipline.discipline.id)
        expect(results.sort_by(&:rank).map(&:competitor)).to eq [@first_place.competitor, @second_place.competitor, @third_place.competitor]
      end
    end

  end
end
