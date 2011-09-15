class Discipline < ActiveRecord::Base

  validates_presence_of :name, :abbreviation

  has_many :event_disciplines
  has_many :events, :through => :event_disciplines

  scope :ordered, order('position ASC')
  scope :active, where(:active => true)

end
