require 'spec_helper'

RSpec.describe User, type: :model do

  describe "required attributes" do
    before(:each) do
      @user = User.new
    end

    it "should be invalid without a full_name" do
      expect(@user).not_to be_valid
    end

  end

  describe "#activate_membership!" do
    before(:each) do
      @user = FactoryGirl.create :user, el_member: false, member_since: nil
      @membership = FactoryGirl.create :membership, user: @user, expires_at: 12.months.from_now.end_of_month, paid: true
    end

    it "should mark the user as an eastern league member" do
      expect(@user.el_member).to be false
      @user.activate_membership!(@membership)
      expect(@user.el_member).to be true
    end

    it "should set the current_through variables" do
      new_expiration_date = 12.months.from_now.end_of_month
      @user.activate_membership!(@membership)
      expect(@user.current_through_date.month).to eq new_expiration_date.month
      expect(@user.current_through_date.year).to eq new_expiration_date.year
    end

    it "should set former_member to false" do
      @user.activate_membership!(@membership)
      expect(@user.former_member).to be false
    end

    it "should update the member_since value" do
      Timecop.freeze
      @user.activate_membership!(@membership)
      expect(@user.member_since).to eq Time.now.utc
      Timecop.return
    end
  end

  describe "#name_with_email" do
    before(:each) do
      @user = FactoryGirl.create :user, full_name: "Test User", email: "testuser@example.com"
    end

    it "should list the full name and obfuscated email address" do
      expect(@user.name_with_email).to eq "Test User, testuser@*******"
    end
  end

  describe "#membership_status" do
    it "should return 'active' for an active user'" do
      @user = FactoryGirl.create :active_user
      expect(@user.membership_status).to eq 'active'
    end

    it "should return 'active' for a board member" do
      @user = FactoryGirl.create :board_member_user
      expect(@user.membership_status).to eq 'active'
    end

    it "should return 'active' for a lifetime member" do
      @user = FactoryGirl.create :lifetime_member_user
      expect(@user.membership_status).to eq 'active'
    end

    it "should return 'expired' for an expired user" do
      @user = FactoryGirl.create :expired_user
      expect(@user.membership_status).to eq 'expired'
    end

    it "should return 'expiring_soon' for a user whose membership will expire inside of 30 days" do
      @user = FactoryGirl.create :expiring_soon_user
      expect(@user.membership_status).to eq 'expiring_soon'
    end
  end

  describe "#related_users" do
    before(:each) do
      @second_family_membership = FactoryGirl.create :membership
      @third_family_membership  = FactoryGirl.create :membership
      @unrelated_membership     = FactoryGirl.create :membership, primary_member: true
      @primary_membership = FactoryGirl.create :membership, primary_member: true, family_memberships: [@second_family_membership, @third_family_membership]
      @primary_user = @primary_membership.user
      @second_family_membership.update_attribute(:primary_user_id, @primary_user.id)
      @third_family_membership.update_attribute(:primary_user_id, @primary_user.id)
    end

    it "should correlate related members together" do
      expect(@primary_user.related_users).to eq [@second_family_membership.user, @third_family_membership.user]
    end
  end

  describe "#deliver_password_reset_instructions!" do
    before(:each) do
      @user = FactoryGirl.create :active_user
      @mailer = double("UserMailer", deliver: true)
      expect(UserMailer).to receive(:password_reset_instructions).with(@user).and_return(@mailer)
    end

    it "should change the perishable token" do
      expect { @user.deliver_password_reset_instructions! }.to change(@user, :perishable_token)
    end

  end

  describe "#primary_member?" do
    before(:each) do
      @user = FactoryGirl.create :active_user
    end

    describe "when user has no membership records" do
      it "should return true" do
        expect(@user.primary_member?).to be true
      end
    end

    describe "when user has one or more membership records as primary" do
      it "should return true" do
        FactoryGirl.create :membership, primary_member: true, expires_at: Date.today.advance(months: 12).to_time.end_of_month, user: @user
        FactoryGirl.create :membership, primary_member: true, expires_at: 1.month.ago.to_time.end_of_month, user: @user
        expect(@user.primary_member?).to be true
      end
    end

    describe "when user is not the primary member" do
      it "should return false" do
        FactoryGirl.create :membership, primary_member: false, expires_at: Date.today.advance(months: 12).to_time.end_of_month, user: @user
        expect(@user.primary_member?).to be false
      end
    end
  end

  describe "#as_json" do
    it "should return the JSON version of a user object" do
      @user = FactoryGirl.create(:competitor).user
      expect(@user.as_json).to eq({ id: @user.id, label: @user.full_name, competitor_id: @user.competitor.id })
    end
  end

  describe "creating a legacy user" do
    it "should set a current_through_date based on month and year parameters" do
      @future_date = 1.month.from_now
      @user = FactoryGirl.create(:user, current_through_month: @future_date.month, current_through_year: @future_date.year)
      expect(@user.current_through_date).to eq @future_date.to_date.end_of_month
    end
  end

end
