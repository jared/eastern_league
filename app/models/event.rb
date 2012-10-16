class Event < ActiveRecord::Base
  acts_as_commentable

  has_attached_file :registration_form
  before_post_process :forbid_pdf  # prevent post-processing on PDF uploads

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

  scope :calendar, order("start_date ASC")

  def self.most_recent
    @season = Season.current
    return @season.scores.order("id DESC").first.event
  end

  def validate_date_escalation
    errors.add(:end_date, "must be after Start Date") if self[:start_date] > self[:end_date]
  end

  def event_dates
    [self.start_date.strftime('%b %e'), self.end_date.strftime('%e %Y')].join("-")
  end

private
  def forbid_pdf
    return false if (data_content_type =~ /application\/.*pdf/)
  end


end
