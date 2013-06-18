class Standing < ActiveRecord::Base

  belongs_to :season
  belongs_to :competitor
  belongs_to :discipline

  # Virtual Attributes for Tie Breakers
  attr_accessor :tie_breaker_one_points
  attr_accessor :tie_breaker_two_points
  attr_accessor :average_flight_score

  # Tie Breaker Criteria
  #
  def self.calculate_standings(season, final = false)
    discipline_scores = season.scores.group_by(&:discipline)

    discipline_scores.each do |discipline, scores|
      Standing.calculate_discipline_standings(discipline, scores, season)
      Standing.calculate_rank(discipline, season, final)
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

  def self.calculate_rank(discipline, season, final = false)
    standings = season.standings.where(:discipline_id => discipline.id).order("points DESC")

    # Give everyone a rank, disregard ties (for now)
    # This routine will assign multiple competitors to the same rank if their points are tied.
    standings.each_with_index do |standing, i|
      if i > 0 && standing.points == standings[i-1].points
        standing.update_attribute(:rank, standings[i-1].rank)
      else
        standing.update_attribute(:rank, i+1)
      end
    end

    if final

      # Look for ties, and resolve them according to tie breaker criteria.
      standings.group_by(&:points).each do |points, standings|
        if standings.size > 1
          tb1 = Standing.tie_breaker_one(discipline, standings, season)
          next if tb1
          tb2 = Standing.tie_breaker_two(discipline, standings, season)
          next if tb2
          tb3 = Standing.tie_breaker_three(discipline, standings, season)
        end
      end

    end
  end


  # Head-to-head. For all events in which the two competitors competed against each other,
  # the total number of Eastern League points awarded to each competitor is counted.
  # The higher number wins.
  def self.tie_breaker_one(discipline, standings, season)
    events_attended = {}
    standings.each do |standing|
      scores = season.scores.where(:competitor_id => standing.competitor_id).select { |score| score.discipline.id == standing.discipline.id }
      events_attended[standing.competitor.id] = scores.map(&:event).map(&:id)
    end

    overlapping_events = []
    events_attended.each do |competitor, events|
      events.each do |event|
        overlapping_events << event if events_attended.all?{|c,e| e.include?(event) } && !overlapping_events.include?(event)
      end
    end

    return false if overlapping_events.empty?

    overlapping_events.each do |event|
      standings.each do |standing|
        scores = discipline.scores.where(:competitor_id => standing.competitor_id, :season_id => season.id).select { |score| overlapping_events.include?(score.event.id) }
        standing.tie_breaker_one_points = scores.sum(&:points)
      end
    end

    standings.group_by(&:tie_breaker_one_points).each do |points, standings|
      return false if standings.size > 1
    end

    standings.sort_by(&:tie_breaker_one_points).reverse.each_with_index do |standing, i|
      tmp_rank = standing.rank
      standing.rank = tmp_rank + i
      standing.tie_breaker = "TB1: #{standing.tie_breaker_one_points.round(2)}"
      standing.save
    end
    return true
  end

  # Total points. The total number of Eastern League points for all events
  # in which each competitor competed is compared. The higher number wins.
  def self.tie_breaker_two(discipline, standings, season)
    standings.each do |standing|
      scores = discipline.scores.where(:competitor_id => standing.competitor_id, :season_id => season.id)
      standing.tie_breaker_two_points = scores.map(&:points).sum
    end

    standings.group_by(&:tie_breaker_two_points).each do |points, standings|
      return false if standings.size > 1
    end

    standings.sort_by(&:tie_breaker_two_points).reverse.each_with_index do |standing, i|
      tmp_rank = standing.rank
      standing.rank = tmp_rank + i
      standing.tie_breaker = "TB2: #{standing.tie_breaker_two_points.round(2)}"
      standing.save
    end
    return true
  end

  # Average flight score. The actual flight scores for every competition in which each competitor competed are averaged,
  # and this number is compared for the two competitors. The higher number wins.
  def self.tie_breaker_three(discipline, standings, season)
    standings.each do |standing|
      flight_scores = discipline.scores.where(:competitor_id => standing.competitor_id, :season_id => season.id).map(&:score)
      standing.average_flight_score = (flight_scores.sum / flight_scores.size)
    end

    standings.sort_by(&:average_flight_score).reverse.each_with_index do |standing, i|
      tmp_rank = standing.rank
      standing.rank = tmp_rank + i
      standing.tie_breaker = "TB3: #{standing.average_flight_score.round(2)}"
      standing.save
    end
  end

end
