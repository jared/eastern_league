class Competitor < ActiveRecord::Base
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>"}
  
  belongs_to :user
  
  has_many :team_members, :foreign_key => "team_id"
  has_many :competitors, :through => :team_members
  
  has_many :inverse_team_members, :class_name => "TeamMember", :foreign_key => "competitor_id"
  has_many :teams, :through => :inverse_team_members, :conditions => { :team => true }
  has_many :pairs, :through => :inverse_team_members, :conditions => { :pair => true }, :source => :team
  
  scope :teams, where(:team => true)
  scope :pairs, where(:pair => true)
  
  def name
    return self[:name] if team? || pair?
    self.user.full_name
  end

end
