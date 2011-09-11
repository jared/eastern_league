class Season < ActiveRecord::Base

  has_many :events

  validates_presence_of :year, :start_date, :end_date

  def self.current
    find(:first, :conditions => { :current => true })
  end

end
