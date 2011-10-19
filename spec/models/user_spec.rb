require 'spec_helper'

describe User do

  describe "required attributes" do
    before(:each) do
      @user = User.new
    end

    it "should be invalid without a full_name" do
      @user.should_not be_valid
      @user.should have(1).error_on(:full_name)
    end

    it "should be invalid without an email" do
      @user.should_not be_valid
      @user.should have(1).error_on(:email)
    end

    it "should be invalid without a password" do
      @user.should_not be_valid
      @user.should have(1).error_on(:password)
    end
  end

  describe "#activate_membership!" do
    before(:each) do
      @user = Factory :user, :el_member => false, :member_since => nil
      @membership = Factory :membership, :user => @user, :expires_at => 12.months.from_now.end_of_month, :paid => true
    end

    it "should mark the user as an eastern league member" do
      @user.el_member.should be_false
      @user.activate_membership!(@membership)
      @user.el_member.should be_true
    end

    it "should set the current_through variables" do
      new_expiration_date = 12.months.from_now.end_of_month
      @user.activate_membership!(@membership)
      @user.current_through_date.month.should == new_expiration_date.month
      @user.current_through_date.year.should == new_expiration_date.year
    end

    it "should set former_member to false" do
      @user.activate_membership!(@membership)
      @user.former_member.should be_false
    end

    it "should update the member_since value" do
      Timecop.freeze
      @user.activate_membership!(@membership)
      @user.member_since.should == Time.now.utc
      Timecop.return
    end

  end

  describe "#name_with_email" do
    before(:each) do
      @user = Factory :user, :full_name => "Test User", :email => "testuser@example.com"
    end

    it "should list the full name and obfuscated email address" do
      @user.name_with_email.should == "Test User, testuser@*******"
    end

  end

end
