class Event < ActiveRecord::Base
  acts_as_commentable

  belongs_to :organizer, :class_name => "User", :foreign_key => "organizer_id"
  belongs_to :season

  has_one :event_detail
  has_many :event_disciplines
  has_many :event_sponsors

  has_many :event_registrations

  has_many :disciplines, :through => :event_disciplines
  has_many :scores, :through => :event_disciplines


  accepts_nested_attributes_for :event_detail
  accepts_nested_attributes_for :event_sponsors

  validates_presence_of :name, :season_id, :location
  validate :validate_date_escalation, :if => Proc.new { |event| !event.start_date.blank? && !event.end_date.blank? }
  validates :base_rate, presence: true
  validates :discipline_rate, presence: true

  scope :calendar, -> { order("start_date ASC") }

  def self.most_recent
    @season = Season.current
    if @season.scores.empty?
      @season = Season.where(:id => (@season.id - 1)).first
    end
    return @season.scores.order("id DESC").first.event
  end

  def validate_date_escalation
    errors.add(:end_date, "must be after Start Date") if self[:start_date] > self[:end_date]
  end

  def event_dates
    end_date_str = '%e %Y'
    end_date_str = '%b %e %Y' if self.start_date.month != self.end_date.month
    [self.start_date.strftime('%b %e'), self.end_date.strftime(end_date_str)].join("-")
  end

end
