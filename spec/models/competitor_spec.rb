require 'spec_helper'

describe Competitor do

  describe "solo competitor" do
    before(:each) do
      @user = Factory :user, :full_name => "Testing User"
      @competitor = Factory :competitor, :user => @user
    end
    
    describe "#name" do
      it "should return the name of the assocation user" do
        @competitor.name.should == "Testing User"
      end
    end
    
    describe "associations" do
      before(:each) do
        @team1 = Factory :team, :name => "Team 1"
        @team2 = Factory :team, :name => "Team 2"
        @team3 = Factory :team, :name => "Team 3"
        @pair1 = Factory :pair, :name => "Pair 1"
        @pair2 = Factory :pair, :name => "Pair 2"
        @team_member1 = Factory :team_member, :competitor => @competitor, :team => @team1
        @team_member2 = Factory :team_member, :competitor => @competitor, :team => @team2
        @team_member3 = Factory :team_member, :competitor => @competitor, :team => @pair1
      end
      describe "#teams" do
        it "should return a list of teams the competitor is associated with" do
          @competitor.teams.should == [@team1, @team2]
        end
        
        it "should not include any pair groupings for that competitor" do
          @competitor.teams.should_not include(@pair1)
        end
        
      end
      describe "#pairs" do
        it "should return the list of pairs the competitor is associated with" do
          @competitor.pairs.should == [@pair1]
        end
        
        it "should not include any team groupings for that competitor" do
          @competitor.pairs.should_not include(@team1)
          @competitor.pairs.should_not include(@team2)
        end
      end
    end
  end
  
  describe "pair competitor" do
    before(:each) do
      @pair = Factory :pair, :user => nil
    end
    
    describe "#name" do
      it "should provide the name of the pair" do
        @pair.name.should == "Dueling Sabers"
      end
    end
  end
  
  describe "team competitor" do
    before(:each) do
      @team = Factory :team, :user => nil
    end
    
    describe "#name" do
      it "should provide the name of the pair" do
        @team.name.should == "Rusty Sabers"
      end
    end
    
    describe "associations" do
      before(:each) do
        @competitor = Factory :competitor
        Factory :team_member, :team => @team, :competitor => @competitor, :captain => true
        2.times { Factory :team_member, :team => @team }
      end
      
      it "should return 3 competitors on the team" do
        @team.competitors.size.should == 3
      end
      
    end
    
    
  end
end
