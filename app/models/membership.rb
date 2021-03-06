class Membership < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :membership_plan
  belongs_to :primary_user, class_name: "User", foreign_key: "primary_user_id"

  has_many :family_memberships, class_name: "Membership", foreign_key: "primary_membership_id"

  validates_presence_of :membership_plan_id

  scope :newest, -> { order("expires_at DESC") }

  def self.find_due(time = Time.now)
    where(primary_member: true, expires_at: (time..time.end_of_month)).select do |membership|
      membership.user.current_through_date <= time.end_of_month.to_date
    end
  end

  def activate!(renewal_date = Date.today, send_email = true)

    # If the user does not have a current_through_date, add additional time from today's date.
    # If the user has a current_through_date, and that date is in the past, add additional time from today's date.
    # If the user has a current_through_date, and that date is in the future, add additional time to that date.

    new_expires_at = renewal_date.advance(months: membership_plan.renewal_period).to_time.end_of_month
    if user.current_through_date.present? && user.current_through_date >= Date.today
      new_expires_at = user.current_through_date.advance(months: membership_plan.renewal_period).to_time.end_of_month
    end

    attrs = {
      expires_at: new_expires_at,
      paid:       true
    }
    self.update_attributes!(attrs)
    user.activate_membership!(self)
    if send_email
      UserMailer.membership_purchased(self).deliver unless self.user.temporary_email?
    end
  end

end
