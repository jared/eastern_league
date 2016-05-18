class RegistrationDiscipline < ActiveRecord::Base

  belongs_to :event_registration
  belongs_to :event_discipline

  scope :for_discipline, -> (discipline_ids) { includes(event_discipline: :discipline).where("disciplines.id IN (?)", discipline_ids) }

  # def self.for_discipline(discipline_id)
  #   includes(:event_discipline => :discipline).where("disciplines.id = ?", discipline_id).first
  # end

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

  def free?
    event_discipline.free?
  end

end
