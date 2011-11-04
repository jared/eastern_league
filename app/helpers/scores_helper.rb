module ScoresHelper
  def score_name_and_link(score)
    if score.competitor.pair? || score.competitor.team?
      score.competitor.name
    else
      link_to score.competitor.name, user_path(score.competitor.user)
    end
  end
end
