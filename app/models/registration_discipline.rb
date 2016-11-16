class RegistrationDiscipline < ActiveRecord::Base

  belongs_to :event_registration
  belongs_to :event_discipline

  scope :for_discipline, -> (discipline_ids) { joins(event_discipline: :discipline).includes(event_discipline: :discipline).where("disciplines.id IN (?)", discipline_ids) }

  delegate :free?, to: :event_discipline

  def abbrev_and_members
    str = event_discipline.abbreviation
    if [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 26, 27, 28, 29].include?(event_discipline.discipline.id)
      str += " #{self.group_name}"
      str += " (#{self.group_members})"
    end
    str
  end

end
