class JacketsController < ApplicationController

  before_filter :require_user

  def index
    authorize! :manage, Jacket.new, :message => "Only an administrator may view the list of jacket orders."
    @jackets = Jacket.all
  end

  def new
    @season = Season.find_by_year("2013")
    @jacket = Jacket.new(:season => @season, :name => current_user.full_name)
  end

  def create
    @jacket = Jacket.new(params[:jacket])
    if @jacket.save
      amount = @jacket.price
      if @jacket.delivery?
        amount += 9.00
      end
      @order = current_user.orders.build(:description => "Award Jacket for #{current_user.full_name}")
      @order.line_items.build(:purchasable => @jacket, :amount => amount, :description => "2012 Jacket")

      @order.save
      flash[:notice] = "Your jacket information has been saved."
      redirect_to purchase_user_order_path(current_user, @order) and return
    end
  end

end
