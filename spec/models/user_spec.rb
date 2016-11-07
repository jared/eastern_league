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

end
