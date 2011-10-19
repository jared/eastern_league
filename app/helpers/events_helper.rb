module EventsHelper
  
  def status_name_and_link(event)
    case event.status
    when "Results Available"
      link_to event.status, event_path(event)
    else
      event.status
    end
  end
  
  def score_name_and_link(score)
    if score.competitor.pair? || score.competitor.team?
      score.competitor.name
    else
      link_to score.competitor.name, user_path(score.competitor.user)
    end
  end
  
end
