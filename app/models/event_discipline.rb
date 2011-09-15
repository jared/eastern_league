class EventDiscipline < ActiveRecord::Base

  belongs_to :discipline
  belongs_to :event

end
