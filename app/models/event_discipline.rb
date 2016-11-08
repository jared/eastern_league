class EventDiscipline < ActiveRecord::Base

  belongs_to :discipline
  belongs_to :event
  has_many :scores

  delegate :name, :abbreviation, :free?, to: :discipline
end
