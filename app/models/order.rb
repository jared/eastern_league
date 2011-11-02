class Order < ActiveRecord::Base
  require 'el_crypto'

  belongs_to :user

  has_many :line_items, :dependent => :destroy

  after_create  :calculate_amount, :encrypt_payment_data

private

  def calculate_amount
    self.update_attribute(:amount, self.line_items.sum(:amount))
  end

  def encrypt_payment_data
    self.update_attribute(:encrypted_data, ElCrypto::EncryptedOrder.new(self).encrypted_data)
  end


end
