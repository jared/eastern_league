class Season < ActiveRecord::Base

  has_many :events
  has_many :scores

  has_many :standings

  validates_presence_of :year, :start_date, :end_date

  scope :with_standings, includes(:standings).where(["standings.season_id = seasons.id"]).order("year ASC")

  def self.current
    find(:first, :conditions => { :current => true })
  end

end
