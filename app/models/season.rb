class Season < ActiveRecord::Base

  has_many :events
  has_many :scores

  has_many :standings

  before_save :check_and_update_current

  validates_presence_of :year, :start_date, :end_date

  scope :with_standings, -> { joins(:standings).includes(:standings).where(["standings.season_id = seasons.id"]).order("year ASC") }

  def self.current
    where(current: true).first
  end

private

  def check_and_update_current
    if !!self[:current]
      Season.update_all current: false
    end
  end

end
