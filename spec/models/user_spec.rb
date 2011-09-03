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

end
