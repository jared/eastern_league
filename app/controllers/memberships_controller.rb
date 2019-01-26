class MembershipsController < ApplicationController

  # NOTE: See `load_user` method for membership renewal suspension.  Jan 26 2019 per JW

  before_filter :require_user

  def index
    load_user
    @memberships = @user.memberships.newest
  end

  def new
    flash[:notice] = "Online membership renewal is currently unavailable.  Please try again later!"
    redirect_to root_path and return
    # load_user
    # unless @user.primary_member?
    #   flash[:error] = "Your membership type must be renewed by the primary member.  Please ask #{@user.memberships.newest.first.primary_user.full_name} to renew on your behalf."
    #   redirect_to root_path and return
    # end
    # @membership = @user.memberships.build
  end

  def confirm
    load_user
    @membership = @user.memberships.build(membership_params)
    if @membership.valid?
      plan = @membership.membership_plan
      @additional_members = []
      params[:additional_members].reject{ |am| am.blank? }.each do |full_name|
        @additional_members << User.where(full_name: full_name).first_or_initialize #find_or_initialize_by_full_name(full_name)
      end
      @amount = plan.amount
      if @additional_members.size > 0
        @family_plan = MembershipPlan.where(name: plan.name.gsub(/Individual/, "Family")).first #find_by_name()
        @amount += (@additional_members.size * @family_plan.amount)
      end
    else
      render :action => :new
    end
  end

  def create
    flash[:notice] = "Online membership renewal is currently unavailable.  Please try again later!"
    redirect_to root_path and return

    # load_user
    # @order = @user.orders.build(:description => "Eastern League Membership")
    # @membership = @user.memberships.create(membership_params)
    # @order.line_items.build(:purchasable => @membership, :amount => @membership.membership_plan.amount, :description => "#{@membership.membership_plan.name} for #{@membership.user.full_name}")

    # @additional_members = []

    # # Create user records & membership records for totally new users
    # if params[:new_additional_members]
    #   params[:new_additional_members].each do |am_params|
    #     family_user = User.create(:full_name    => am_params[:full_name],
    #                               :nickname     => am_params[:full_name].split(" ").first,
    #                               :email        => am_params[:email],
    #                               :password     => am_params.map{|k,v|v}.<<(Time.now.to_i).join("")) # Set a temporary gibberish password to save the record.
    #     family_membership = family_user.memberships.create(:membership_plan_id => params[:family_plan_id],
    #                                                        :primary_user_id => @user.id,
    #                                                        :primary_membership_id => @membership.id,
    #                                                        :primary_member => false)
    #     @additional_members << family_user
    #     @order.line_items.build(:purchasable => family_membership, :amount => family_membership.membership_plan.amount, :description => "#{family_membership.membership_plan.name} for #{family_user.full_name}")
    #   end
    # end

    # if params[:additional_members]
    #   params[:additional_members].each do |am_id|
    #     family_user = User.find(am_id)
    #     family_membership = family_user.memberships.create(:membership_plan_id => params[:family_plan_id],
    #                                                        :primary_user_id => @user.id,
    #                                                        :primary_membership_id => @membership.id,
    #                                                        :primary_member => false)
    #     @additional_members << family_user
    #     @order.line_items.build(:purchasable => family_membership, :amount => family_membership.membership_plan.amount, :description => "#{family_membership.membership_plan.name} for #{family_user.full_name}")
    #   end
    # end
    # @order.save
    # if current_user.admin? && !params[:record_manual_payment_date].blank?
    #   payment_date = Date.parse(params[:record_manual_payment_date])
    #   @order.line_items.each do |line_item|
    #     line_item.purchasable.activate!(payment_date, false)
    #   end
    #   flash[:notice] = "You have processed a manual membership renewal."
    #   redirect_to user_memberships_path(@user) and return
    # else
    #   redirect_to purchase_user_order_path(@user, @order) and return
    # end
  end

private

  def load_user
    @user = User.find(params[:user_id])
  end

  def membership_params
    params.require(:membership).permit!
  end

end
