class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  before_create :set_full_name

  validates_presence_of :first_name, :last_name

  def current_through_date=(date)
    self[:current_through_year] = date.year
    self[:current_through_month] = date.month
  end

  def current_through_date
    Date.new(self[:current_through_year], self[:current_through_month], 1).end_of_month
  end

private

  def set_full_name
    self[:full_name] = "#{self[:first_name]} #{self[:last_name]}"
  end

end
