class ScoresController < ApplicationController
  
  before_filter :require_user
  
  def new
    @event = Event.find(params[:event_id])
  end
  
  def create
    @event = Event.find(params[:event_id])
    scores = []
    params[:scores].each do |score_attrs|
      scores << Score.create(score_attrs.merge(:event_discipline_id => params[:event_discipline_id]))
    end
    
    # magic here to calculate points
    
    redirect_to @event
  end
  
end
