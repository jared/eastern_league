class OrdersController < ApplicationController

  before_filter :require_user

  def purchase
    load_user
    @order = @user.orders.find(params[:id])
  end

  def thank_you
    flash[:notice] = "Your order has been received!"
    load_user
    @order = @user.orders.find(params[:id])
  end

private
  def load_user
    @user = User.find(params[:user_id])
  end

end
