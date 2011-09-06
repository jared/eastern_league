class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  validates_presence_of :full_name

  has_many :memberships
  has_many :family_memberships, :class_name => "Membership", :foreign_key => "primary_user_id"

  has_many :orders

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

  def current_through_date=(date_string)
    date = Date.parse(date_string)
    self[:current_through_year] = date.year
    self[:current_through_month] = date.month
  end

  def current_through_date
    Date.new(self[:current_through_year], self[:current_through_month], 1).end_of_month
  end

  def name_with_email
    "#{self[:full_name]}, #{self[:email].gsub(/@.*/, '@' + '*' * 7)}"
  end

end
