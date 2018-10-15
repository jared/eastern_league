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
    score_params[:scores].each do |score_attrs|
      scores << Score.create(score_attrs.merge(event_discipline_id: params[:event_discipline_id], 
                                               season_id:           @event.season.id))
    end
    
    @event_discipline = EventDiscipline.find(params[:event_discipline_id])
    
    Score.calculate_points(@event_discipline, %w(EPP EPB MPP MPB ETP ETB MTP MTB OTT OTP OTB OTMB OPMB).include?(@event_discipline.discipline.abbreviation))
    
    redirect_to new_event_score_path(@event)
  end

  def remove
    load_event
    @event_discipline = @event.event_disciplines.find(params[:event_discipline_id])
    @scores = @event.scores.find(params[:score_ids])
    @scores.each { |score| score.destroy }
    flash[:notice] = "Scores for #{@event_discipline.name} removed.  Re-enter scores and then re-calculate standings."
    redirect_to event_scores_path(@event) and return
  end
  
private

  def load_event
    @event = Event.find(params[:event_id])
  end
  
  def score_params
    params.permit!
  end

end
