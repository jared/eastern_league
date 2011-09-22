class TeamMember < ActiveRecord::Base
  
  belongs_to :competitor
  belongs_to :team, :class_name => "Competitor", :foreign_key => "team_id"
  
end
