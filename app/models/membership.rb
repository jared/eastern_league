class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :membership_plan

  has_many :line_items, :as => :purchasable

  validates_presence_of :membership_plan_id

  def activate!
    attrs = {
      :expires_at => membership_plan.renewal_period.months.from_now.end_of_month,
      :paid       => true
    }
    self.update_attributes!(attrs)
    user.activate_membership!(self)
  end

end
