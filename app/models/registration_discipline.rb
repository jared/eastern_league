class RegistrationDiscipline < ActiveRecord::Base
  
  belongs_to :event_registration
  belongs_to :event_discipline
  
end
