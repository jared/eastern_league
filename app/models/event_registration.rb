class EventRegistration < ActiveRecord::Base

  belongs_to :competitor
  belongs_to :event

  has_one :line_item, :as => :purchasable

  has_many :registration_disciplines, :dependent => :destroy
  has_many :event_disciplines, :through => :registration_disciplines
  has_many :disciplines, :through => :event_disciplines

  def op_team_name
    self.registration_disciplines.for_discipline([13,14,15,16]).first.try(:group_name)
  end

  def op_team_members
    self.registration_disciplines.for_discipline([13,14,15,16]).first.try(:group_members)
  end

  def ot_team_name
    self.registration_disciplines.for_discipline([17, 18, 19, 20, 21, 22]).first.try(:group_name)
  end

  def ot_team_members
    self.registration_disciplines.for_discipline([17, 18, 19, 20, 21, 22]).first.try(:group_members)
  end

  def ott_team_name
    self.registration_disciplines.for_discipline(23).first.try(:group_name)
  end

  def ott_team_members
    self.registration_disciplines.for_discipline(23).first.try(:group_members)
  end

  def omt_team_name
    self.registration_disciplines.for_discipline([26,27]).first.try(:group_name)
  end

  def omt_team_members
    self.registration_disciplines.for_discipline([26,27]).first.try(:group_members)
  end

  def omp_team_name
    self.registration_disciplines.for_discipline([28,29]).first.try(:group_name)
  end

  def omp_team_members
    self.registration_disciplines.for_discipline([28,29]).first.try(:group_members)
  end



end
