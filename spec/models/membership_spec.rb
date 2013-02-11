require 'spec_helper'

describe Membership do

  describe "#activate!" do
    before(:each) do
      @user = FactoryGirl.create :user
      @user.stub!(:activate_membership!).and_return(true)
      @membership_plan = FactoryGirl.create :membership_plan, :name => "1 Year Individual", :renewal_period => 12

      @membership = FactoryGirl.create :membership, :user => @user, :paid => false, :expires_at => nil, :membership_plan => @membership_plan
    end

    it "should save the membership" do
      @membership.should_receive(:save!).and_return(true)
      @membership.activate!
    end

    it "should set paid to true" do
      @membership.activate!
      @membership.paid.should be_true
    end

    it "should set the expires at" do
      @membership.activate!
      @membership.expires_at.should == Date.today.advance(:months => 12).to_time.end_of_month
    end

    it "should set the expires at when given a custom payment date" do
      renewal_date = 45.days.ago
      @membership.activate!(renewal_date)
      @membership.expires_at.should == renewal_date.advance(:months => 12).to_time.end_of_month
    end

    it "should update the user record" do
      @user.should_receive(:activate_membership!).with(@membership).and_return(true)
      @membership.activate!
    end

  end

end
