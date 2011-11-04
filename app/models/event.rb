class Event < ActiveRecord::Base

  belongs_to :organizer, :class_name => "User", :foreign_key => "organizer_id"
  belongs_to :season

  has_many :event_disciplines
  has_many :disciplines, :through => :event_disciplines
  has_many :scores, :through => :event_disciplines
  
  has_one :event_detail
  
  accepts_nested_attributes_for :event_detail
  
  validates_presence_of :name, :season_id, :location
  validate :validate_date_escalation, :if => Proc.new { |event| !event.start_date.blank? && !event.end_date.blank? }
  
  scope :calendar, order("start_date ASC")

  def validate_date_escalation
    errors.add(:end_date, "must be after Start Date") if self[:start_date] > self[:end_date]
  end
  
  def event_dates
    [self.start_date.strftime('%b %e'), self.end_date.strftime('%e %Y')].join("-")
  end
  

end
