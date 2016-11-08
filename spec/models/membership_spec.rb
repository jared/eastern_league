require 'spec_helper'

RSpec.describe Membership, type: :model do

  before(:each) do
    @membership_plan = FactoryGirl.create :membership_plan, name: "1 Year Individual", renewal_period: 12
  end

  describe "#activate!" do
    before(:each) do
      @user = FactoryGirl.create :user
      allow(@user).to receive_messages(activate_membership!: true)
    end

    describe "when a membership is new or not current" do
      before(:each) do
        @membership = FactoryGirl.create :membership, user: @user, paid: false, expires_at: nil, membership_plan: @membership_plan
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
        expect(@membership.expires_at).to eq Date.today.advance(months: 12).to_time.end_of_month
      end

      it "should set the expires at when given a custom payment date" do
        renewal_date = 45.days.ago
        @membership.activate!(renewal_date)
        expect(@membership.expires_at).to eq renewal_date.advance(months: 12).to_time.end_of_month
      end
    end

    describe "when a membership is already active" do
      before(:each) do
        @user = FactoryGirl.create :active_user
        @membership = FactoryGirl.create :membership, user: @user, paid: false, expires_at: Date.today.advance(months: 6).to_time.end_of_month, membership_plan: @membership_plan
      end

      it "should advance the expiration date by 12 months" do
        @membership.activate!
        expect(@membership.expires_at).to eq Date.today.advance(months: 18).to_time.end_of_month
      end
    end
  end

  describe ".find_due" do
    before(:each) do
      next_year = Date.today.advance(months: 12).to_time.end_of_month
      this_month = Date.today.to_time.end_of_month
      @current_membership  = FactoryGirl.create :membership, paid: true, membership_plan: @membership_plan, expires_at: next_year, user: FactoryGirl.create(:active_user, current_through_date: next_year)
      @expiring_membership = FactoryGirl.create :membership, paid: true, membership_plan: @membership_plan, expires_at: this_month, user: FactoryGirl.create(:active_user, current_through_date: this_month)
    end

    it "should match memberships set to expire this month" do
      expect(Membership.find_due).to eq [@expiring_membership]
    end

    it "should match memberships set to expire in a given month" do
      expect(Membership.find_due(Date.today.advance(months: 12).to_time.end_of_month)).to eq [@current_membership]
    end
  end

end
