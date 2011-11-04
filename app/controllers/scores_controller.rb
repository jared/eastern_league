class ScoresController < ApplicationController
  
  before_filter :require_user, :except => :index
  
  def index
    load_event
  end
  
  def new
    load_event
    authorize! :create, Score
  end
  
  def create
    load_event
    authorize! :create, Score
    scores = []
    params[:scores].each do |score_attrs|
      scores << Score.create(score_attrs.merge(:event_discipline_id => params[:event_discipline_id], :season_id => @event.season.id))
    end
    
    @event_discipline = EventDiscipline.find(params[:event_discipline_id])
    
    Score.calculate_points(@event_discipline, %w(EPP EPB MPP MPB ETP ETB MTP MTB OTT).include?(@event_discipline.discipline.abbreviation))
    
    redirect_to @event
  end
  
private

  def load_event
    @event = Event.find(params[:event_id])
  end
  
end
