class Competitor < ActiveRecord::Base
  
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  belongs_to :user
  
  has_many :team_members, foreign_key: "team_id"
  has_many :competitors, through: :team_members
  
  has_many :inverse_team_members, class_name: "TeamMember", foreign_key: "competitor_id"
  has_many :teams, -> { where team: true }, through: :inverse_team_members
  has_many :pairs, -> { where pair: true }, through: :inverse_team_members, source: :team
  
  has_many :event_disciplines
  has_many :scores

  has_many :event_registrations

  has_many :standings
  
  scope :teams, -> { where(team: true) }
  scope :pairs, -> { where(pair: true) }
  
  scope :alphabetical, -> {includes(:user).order("users.full_name ASC, name ASC")}
  
  def name
    return self[:name] if team? || pair?
    self.user.try(:full_name)
  end

end
