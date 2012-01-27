class Standing < ActiveRecord::Base
  
  belongs_to :season
  belongs_to :competitor
  belongs_to :discipline
  
  attr_accessor :total_points
  attr_accessor :average_flight_scorea
  attr_accessor :events_attended
  
  # Tie Breaker Criteria
  #   
  def self.calculate_standings(season)
    discipline_scores = season.scores.group_by(&:discipline)
    
    discipline_scores.each do |discipline, scores|
      Standing.calculate_discipline_standings(discipline, scores, season)
      Standing.calculate_rank(discipline, season)
    end
  end
  
  def self.calculate_discipline_standings(discipline, scores, season)
    scores.group_by(&:competitor).each do |competitor, scores|
      eligible_points = scores.map(&:points).sort.reverse[0..4]
      standing = Standing.find_or_initialize_by_competitor_id_and_discipline_id_and_season_id(competitor.id, discipline.id, season.id)
      standing.attributes = {:points => eligible_points.sum, :competition_count => scores.size}
      standing.save
    end
  end
  
  def self.calculate_rank(discipline, season)
    standings = season.standings.where(:discipline_id => discipline.id).order("points DESC")
    standings.each_with_index do |standing, i|
      if i > 0 && standing.points == standings[i-1].points
        standing.update_attribute(:rank, standings[i-1].rank)
      else
        standing.update_attribute(:rank, i+1)
      end
    end
  end
  
  # def self.check_for_ties(discipline, season)
  #   standings = season.standings.where(:discipline_id => discipline.id).order("points DESC")
  #   standings.group_by(&:points).each do |points, standings|
  #     if standings.size > 1
  #       raise standings.inspect
  #     end
  #   end
  # end
  # 
  # def self.tie_breaker_one(standings)
  #   # Head-to-head. For all events in which the two competitors competed against each other, the total number of Eastern League points awarded to each competitor is counted. The higher number wins.
  #   events_attended = []
  #   standings.each do |standing|
  #     scores = season.scores.where(:competitor_id => standing.competitor_id).select { |score| score.discipline == standing.event_discipline.discipline }
  #     standing.events_attended = scores.map(&:event)
  #   end
  # 
  #   false
  # end
  # 
  # def self.tie_breaker_two(standings)
  #   # Total points. The total number of Eastern League points for all events in which each competitor competed is compared. The higher number wins.
  #   standings.each do |standing|
  #     scores = season.scores.where(:competitor_id => standing.competitor_id).select { |score| score.discipline == standing.event_discipline.discipline }
  #     standing.total_points = scores.map(&:points).sum
  #   end
  #   sorted_by_total_score = standings.sort_by{ |standing| standing.total_score }.reverse
  #   
  #   return false unless sorted_by_total_score.size == standings.size
  #   sorted_by_total_score
  # end
  # 
  # def self.tie_breaker_three(standings)
  #   # Average flight score. The actual flight scores for every competition in which each competitor competed are averaged, 
  #   # and this number is compared for the two competitors. The higher number wins.
  #   standings.each do |standing|
  #     flight_scores = season.scores.where(:competitor_id => standing.competitor_id).select { |score| score.discipline == standing.event_discipline.discipline }.map(&:score)
  #     standing.average_flight_score = (flight_scores.sum / flight_scores.size)
  #     standing.tie_breaker = "TB3: #{standing.average_flight_score}"
  #   end
  #   standings.sort_by{ |standing| standing.average_flight_score }.reverse
  # end
    
end
