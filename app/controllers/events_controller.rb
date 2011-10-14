class EventsController < ApplicationController

  before_filter :require_user, :except => :show

  def index
    @events = Event.all(:order => "start_date DESC")
    authorize! :manage, Event
  end
  
  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new(:season => Season.current)
    authorize! :create, Event
  end

  def edit
    @event = Event.find(params[:id])
    authorize! :update, @event
  end

  def create
    @event = Event.new({:status => 'new'}.merge(params[:event]))
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
    if @event.update_attributes(params[:event])
      flash[:notice] = "This event has been updated."
      redirect_to events_path and return
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

end
