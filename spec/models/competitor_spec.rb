require 'spec_helper'

describe Competitor do

  describe "solo competitor" do
    before(:each) do
      @user = FactoryGirl.create :user, :full_name => "Testing User"
      @competitor = FactoryGirl.create :competitor, :user => @user
    end

    describe "#name" do
      it "should return the name of the assocation user" do
        expect(@competitor.name).to eq "Testing User"
      end
    end

    describe "associations" do
      before(:each) do
        @team1 = FactoryGirl.create :team, :name => "Team 1"
        @team2 = FactoryGirl.create :team, :name => "Team 2"
        @team3 = FactoryGirl.create :team, :name => "Team 3"
        @pair1 = FactoryGirl.create :pair, :name => "Pair 1"
        @pair2 = FactoryGirl.create :pair, :name => "Pair 2"
        @team_member1 = FactoryGirl.create :team_member, :competitor => @competitor, :team => @team1
        @team_member2 = FactoryGirl.create :team_member, :competitor => @competitor, :team => @team2
        @team_member3 = FactoryGirl.create :team_member, :competitor => @competitor, :team => @pair1
      end
      describe "#teams" do
        it "should return a list of teams the competitor is associated with" do
          expect(@competitor.teams).to eq [@team1, @team2]
        end

        it "should not include any pair groupings for that competitor" do
          expect(@competitor.teams).not_to include(@pair1)
        end

      end
      describe "#pairs" do
        it "should return the list of pairs the competitor is associated with" do
          expect(@competitor.pairs).to eq [@pair1]
        end

        it "should not include any team groupings for that competitor" do
          expect(@competitor.pairs).not_to include(@team1)
          expect(@competitor.pairs).not_to include(@team2)
        end
      end
    end
  end

  describe "pair competitor" do
    before(:each) do
      @pair = FactoryGirl.create :pair, :user => nil
    end

    describe "#name" do
      it "should provide the name of the pair" do
        expect(@pair.name).to eq "Dueling Sabers"
      end
    end
  end

  describe "team competitor" do
    before(:each) do
      @team = FactoryGirl.create :team, :user => nil
    end

    describe "#name" do
      it "should provide the name of the pair" do
        expect(@team.name).to eq "Rusty Sabers"
      end
    end

    describe "associations" do
      before(:each) do
        @competitor = FactoryGirl.create :competitor
        FactoryGirl.create :team_member, :team => @team, :competitor => @competitor, :captain => true
        2.times { FactoryGirl.create :team_member, :team => @team }
      end

      it "should return 3 competitors on the team" do
        expect(@team.competitors.size).to eq 3
      end

    end


  end
end
