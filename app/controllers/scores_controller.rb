class ScoresController < ApplicationController
  
  before_filter :require_user
  
  def new
    @event = Event.find(params[:event_id])
  end
  
  def create
    @event = Event.find(params[:event_id])
    scores = []
    params[:scores].each do |score_attrs|
      scores << Score.create(score_attrs.merge(:event_discipline_id => params[:event_discipline_id], :season_id => @event.season.id))
    end
    
    @event_discipline = EventDiscipline.find(params[:event_discipline_id])
    
    Score.calculate_points(@event_discipline, %w(EPP EPB MPP MPB ETP ETB MTP MTB OTT).include?(@event_discipline.discipline.abbreviation))
    
    redirect_to @event
  end
  
end
