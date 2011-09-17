class Event < ActiveRecord::Base

  belongs_to :organizer, :class_name => "User", :foreign_key => "organizer_id"
  belongs_to :season

  has_many :event_disciplines
  has_many :disciplines, :through => :event_disciplines

  validates_presence_of :name, :season_id, :location

  scope :calendar, order("start_date ASC")

  def validate
    errors.add(:end_date, "must be after Start Date") if self[:start_date] > self[:end_date]
  end
  
  def event_dates
    [self.start_date.strftime('%b %e'), self.end_date.strftime('%e %Y')].join("-")
  end
  

end
