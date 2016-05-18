class EventDiscipline < ActiveRecord::Base

  belongs_to :discipline
  belongs_to :event
  has_many :scores
  
  def name
    discipline.name
  end
  
  def abbreviation
    discipline.abbreviation
  end

  def free?
    discipline.free?
  end

end
