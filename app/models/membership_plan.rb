class MembershipPlan < ActiveRecord::Base

  has_many :memberships

  scope :visible, :conditions => { :visible => true }
  scope :primary, :conditions => { :primary => true }

end
