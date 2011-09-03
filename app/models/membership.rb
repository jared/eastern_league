class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :membership_plan

  before_create :set_expires_at

  validates_presence_of :membership_plan_id

private

  def set_expires_at
    self[:expires_at] = Date.today.end_of_month + self.membership_plan.renewal_period.months
  end

end
