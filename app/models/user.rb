class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  before_create :set_full_name

  validates_presence_of :first_name, :last_name

private

  def set_full_name
    self[:full_name] = "#{self[:first_name]} #{self[:last_name]}"
  end

end
