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

  # before_create :setup_competitor_record
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

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
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

end
