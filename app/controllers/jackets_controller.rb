class JacketsController < ApplicationController

  before_filter :require_user

  def index
    authorize! :manage, Jacket.new, :message => "Only an administrator may view the list of jacket orders."
    @season = Season.find_by_year(AdminSetting.first.jacket_season)
    @jackets = Jacket.where(season_id: @season.id)
  end

  def new
    @season = Season.find_by_year(AdminSetting.first.jacket_season)
    @jacket = Jacket.new(:season_id => @season.id, :name => current_user.full_name)
  end

  def create
    @jacket = Jacket.new(jacket_params)
    if @jacket.save
      amount = @jacket.price
      if @jacket.delivery?
        amount += 15.00
      end
      @order = current_user.orders.build(:description => "Award Jacket for #{current_user.full_name}")
      @order.line_items.build(:purchasable => @jacket, :amount => amount, :description => "#{@jacket.season.year} Jacket")

      @order.save
      if @order.amount.to_f == 0.00
        flash[:notice] = "Your jacket order has been received."
        redirect_to "/" and return
      else
        flash[:notice] = "Your jacket information has been saved."
        redirect_to purchase_user_order_path(current_user, @order) and return
      end
    else
      @season = @jacket.season
      render action: :new
    end

  end

private
  def jacket_params
    params.require(:jacket).permit(:season_id, :name, :style, :size, :delivery, :typeface, :custom_text_1, :custom_text_2, :custom_text_3)
  end

end
