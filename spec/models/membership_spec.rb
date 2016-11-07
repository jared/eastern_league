require 'spec_helper'

describe Membership do

  describe "#activate!" do
    before(:each) do
      @user = FactoryGirl.create :user
      allow(@user).to receive_messages(activate_membership!: true)
      @membership_plan = FactoryGirl.create :membership_plan, :name => "1 Year Individual", :renewal_period => 12

      @membership = FactoryGirl.create :membership, :user => @user, :paid => false, :expires_at => nil, :membership_plan => @membership_plan
    end

    it "should save the membership" do
      allow(@membership).to receive_messages(save!: true)
      @membership.activate!
    end

    it "should set paid to true" do
      @membership.activate!
      expect(@membership.paid).to be true
    end

    it "should set the expires at" do
      @membership.activate!
      expect(@membership.expires_at).to eq Date.today.advance(:months => 12).to_time.end_of_month
    end

    it "should set the expires at when given a custom payment date" do
      renewal_date = 45.days.ago
      @membership.activate!(renewal_date)
      expect(@membership.expires_at).to eq renewal_date.advance(:months => 12).to_time.end_of_month
    end

  end

end
