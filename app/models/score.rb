class Score < ActiveRecord::Base
  
  BASE_POINTS = { 1 => 25, 2 => 20, 3 => 15, 4 => 12, 5 => 10,
                  6 => 8, 7 => 6, 8 => 4, 9 => 2, 10 => 1}
  
  belongs_to :event_discipline
  belongs_to :competitor
  
  scope :ranked, order("rank ASC")
  
  def self.calculate_points(event_discipline, group=false)
    scores = event_discipline.scores.ranked
    max_bonus = [scores.size, 20].min

    scores.each do |score|
      # Only the top 10 scorers win league points
      next if score.rank > 10
      
      # A disqualification results in a points value of zero
      next if score.disqualified?
      
      # Only Active EL members earn points
      next if !score.competitor.user.el_member?
      
      # Start from zero, apply a base point score according to rank
      tmp_points = 0
      tmp_points += BASE_POINTS[score.rank]
      
      # Calculate bonus points.  Bonus points count double for pairs & team events.
      tmp_bonus = (max_bonus - (score.rank - 1))
      tmp_bonus *= 2 if group

      score.update_attribute(:points, tmp_points + tmp_bonus)
    end
  end
  
end