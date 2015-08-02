class MembershipPlan < ActiveRecord::Base

  has_many :memberships

  scope :visible, -> { where(visible: true) }
  scope :primary, -> { where(primary: true) }

end
