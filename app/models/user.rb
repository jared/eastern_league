class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  validates_presence_of :full_name

  has_many :memberships
  has_many :family_memberships, :class_name => "Membership", :foreign_key => "primary_user_id"

  has_many :orders

  has_one :competitor

  before_create :setup_competitor_record
  before_create :set_current_through_date
  
  accepts_nested_attributes_for :competitor

  def related_users
    self.family_memberships.map(&:user)
  end

  def activate_membership!(member_record)
    self.el_member = true
    self.current_through_date = member_record.expires_at.to_date.to_s
    self.former_member = false
    self.member_since ||= Time.now.utc
    self.save!
  end

  def name_with_email
    "#{self[:full_name]}, #{self[:email].gsub(/@.*/, '@' + '*' * 7)}"
  end
  
  def temporary_email?
    self.email =~ /example.com/
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end

  def primary_member?
    newest_membership = self.memberships.newest.first
    if newest_membership
      newest_membership.primary_member?
    else
      true
    end
  end
  
  def membership_status
    return nil if !el_member?
    return "active" if  board_member? || lifetime? || membership_valid?
    return "expiring_soon" if membership_expiring_soon?
    return "expired" if membership_expired?
  end
    
private

  def setup_competitor_record
    self.build_competitor
  end
  
  def set_current_through_date
    if self[:current_through_month].to_i > 0 && self[:current_through_year].to_i > 0
      self[:current_through_date] = Date.new(self[:current_through_year].to_i, self[:current_through_month].to_i, 1).end_of_month
    end
  end

  def membership_expired?
    self.current_through_date < Date.today
  end
  
  def membership_valid?
    self.current_through_date >= 30.days.from_now.to_date
  end
  
  def membership_expiring_soon?
    self.current_through_date.between?(Date.today,29.days.from_now.to_date)
  end
end
