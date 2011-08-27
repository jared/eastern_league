require 'spec_helper'

describe User do

  describe "required attributes" do
    before(:each) do
      @user = User.new
    end

    it "should be invalid without a first_name" do
      @user.should_not be_valid
      @user.should have(1).error_on(:first_name)
    end

    it "should be invalid without a last_name" do
      @user.should_not be_valid
      @user.should have(1).error_on(:last_name)
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

  describe "before_save" do
    describe "#set_full_name" do
      before(:each) do
        @user = Factory.build :user, :first_name => "Test", :last_name => "User"
      end

      it "should set the user's full name on save" do
        @user.full_name.should be_blank
        @user.save
        @user.full_name.should == "Test User"
      end
    end
  end

end
