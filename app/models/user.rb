class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  before_create :set_full_name

  validates_presence_of :first_name, :last_name

  has_many :memberships

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

private

  def set_full_name
    self[:full_name] = "#{self[:first_name]} #{self[:last_name]}"
  end

end
