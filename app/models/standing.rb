class Standing < ActiveRecord::Base
  
  belongs_to :season
  belongs_to :competitor
  belongs_to :discipline
  
  def self.calculate_standings(season)
    discipline_scores = season.scores.group_by(&:discipline)
    
    discipline_scores.each do |discipline, d_scores|
      d_array = []
      d_scores.group_by(&:competitor).each do |competitor, scores|
        eligible_points = scores.map(&:points).sort.reverse[0..4]
        standing = Standing.find_or_initialize_by_competitor_id_and_discipline_id_and_season_id(competitor.id, discipline.id, season.id)
        standing.attributes(:points => eligible_points.sum, :competition_count => scores.size)
        standing.save
        d_array << standing
      end
      d_array.sort_by { |elem| elem.points }.reverse.each_with_index do |standing, i|
        standing.update_attribute(:rank, i+1)
      end
    end
  end
  
end
