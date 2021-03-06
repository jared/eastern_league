class EventsController < ApplicationController

  before_filter :require_user, :except => [:show, :donate, :raffle_ticket]

  def index
    @events = Event.order "start_date DESC"
    authorize! :manage, Event
  end

  def show
    @event = Event.find(params[:id])
    @event.event_detail ||= EventDetail.new
    @comments = @event.comments.sort_by(&:created_at).reverse
  end

  def donate
    @event = Event.find(params[:id])
    @admin_setting = AdminSetting.first
    @cost = @admin_setting.raffle_ticket_cost
    @tickets_available = @admin_setting.raffle_tickets_per_user
    @commissioner = User.find(@admin_setting.commissioner_user_id)
  end

  def raffle_ticket
    @event = Event.find(params[:id])
    @cost = AdminSetting.first.raffle_ticket_cost
    UserMailer.raffle_ticket_order(@event, params.slice(:name, :street_address, :city_state_zip, :phone, :email, :number_of_donations, :item).merge(:cost => @cost)).deliver
    flash[:notice] = "Thank you, your donation request has been received.  You should receive confirmation via email shortly."
    render :action => :donate
  end

  def new
    @event = Event.new(:season => Season.current)
    @event.build_event_detail
    authorize! :create, Event
  end

  def edit
    @event = Event.find(params[:id])
    @event.build_event_detail unless @event.event_detail
    @event.event_sponsors.build if @event.event_sponsors.empty?
    authorize! :update, @event
  end

  def create
    @event = Event.new({:status => 'new'}.merge(event_params))
    authorize! :create, Event
    if @event.save
      flash[:notice] = "You have successfully created this event."
      redirect_to events_path and return
    else
      flash[:error] = "Unable to save this event to the database."
      render :action => :new
    end
  end

  def update
    @event = Event.find(params[:id])
    authorize! :update, @event
    @event.attributes = event_params
    if @event.save
      flash[:notice] = "This event has been updated."
      redirect_to event_path(@event) and return
    else
      flash[:error] = "Unable to update this event in the database."
      render :action => :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    authorize! :destroy, @event
    @event.destroy
    flash[:notice] = "This event has been deleted."
    redirect_to events_path and return
  end

private
  def event_params
    params.require(:event).permit!
  end

end
