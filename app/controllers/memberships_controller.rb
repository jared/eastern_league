class MembershipsController < ApplicationController

  before_filter :require_user

  def index
    load_user
    render :text => @memberships = @user.memberships
  end

  def new
    load_user
    @membership = @user.memberships.build
  end

  def confirm
    load_user
    @membership = @user.memberships.build(params[:membership])
    if @membership.valid?
      plan = @membership.membership_plan
      @additional_members = []
      params[:additional_members].reject{ |am| am.blank? }.each do |full_name|
        @additional_members << User.find_or_initialize_by_full_name(full_name)
      end
      @amount = plan.amount
      if @additional_members.size > 0
        @family_plan = MembershipPlan.find_by_name(plan.name.gsub(/Individual/, "Family"))
        @amount += (@additional_members.size * @family_plan.amount)
      end
    else
      render :action => :new
    end
  end

  def create
    load_user
    @order = @user.orders.build
    @membership = @user.memberships.create(params[:membership])
    @order.line_items.build(:purchasable => @membership, :amount => @membership.membership_plan.amount, :description => @membership.membership_plan.name)

    @additional_members = []

    # Create user records & membership records for totally new users
    if params[:new_additional_members]
      params[:new_additional_members].each do |am_params|
        family_user = User.create(:full_name   => am_params[:full_name],
                                  :email    => am_params[:email],
                                  :password => am_params.map{|k,v|v}.<<(Time.now.to_i).join("")) # Set a temporary gibberish password to save the record.
        family_membership = family_user.memberships.create(:membership_plan_id => params[:family_plan_id],
                                                           :primary_user_id => @user.id,
                                                           :primary_member => false)
        @additional_members << family_user
        @order.line_items.build(:purchasable => family_membership, :amount => family_membership.membership_plan.amount, :description => family_membership.membership_plan.name)
      end
    end

    if params[:additional_members]
      params[:additional_members].each do |am_id|
        family_user = User.find(am_id)
        family_membership = family_user.memberships.create(:membership_plan_id => params[:family_plan_id],
                                                           :primary_user_id => @user.id,
                                                           :primary_member => false)
        @additional_members << family_user
        @order.line_items.build(:purchasable => family_membership, :amount => family_membership.membership_plan.amount, :description => family_membership.membership_plan.name)
      end
    end
    @order.save
  end

private

  def load_user
    @user = User.find(params[:user_id])
  end

end
