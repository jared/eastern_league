class RegistrationDiscipline < ActiveRecord::Base
  
  belongs_to :event_registration
  belongs_to :event_discipline
  
  def abbrev_and_members
    output = []
    str = event_discipline.abbreviation
    if [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 26, 27, 28, 29].include?(event_discipline.discipline.id)
      str += " #{self.group_name}"
      str += " (#{self.group_members})"
    end
    output << str
    output
  end
  
end
