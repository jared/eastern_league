class EventsController < ApplicationController

  before_filter :require_user

  def index
    @events = Event.all(:order => "start_date DESC")
  end

  def new
    @event = Event.new(:season => Season.current)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new({:status => 'new'}.merge(params[:event]))
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
    if @event.update_attributes(params[:event])
      flash[:notice] = "This event has been updated."
      redirect_to events_path and return
    else
      flash[:error] = "Unable to update this event in the database."
      render :action => :edit
    end
  end

end
