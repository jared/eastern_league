class WildwoodRegistration < ActiveRecord::Base
  serialize :challenges
  serialize :ecskc

  belongs_to :season

  validates_presence_of :name, :address, :city, :state, :zip, :phone, :email

  before_save :set_total_due

  def self.prepare(current_user=nil)
    params = {:season => Season.current}
    if current_user
      params.merge!(:name => current_user.full_name,
                    :address => current_user.street_address_1,
                    :city => current_user.city,
                    :state => current_user.state,
                    :zip => current_user.zip,
                    :phone => current_user.phone_number,
                    :email => current_user.email)
      end
    new(params)
  end

private

  def set_total_due
    tally = 0.0
    self.challenges.each do |item, value|
      tally += value.to_i
    end unless self.challenges.nil?

    self.ecskc.each do |item, value|
      tally += value.to_i
    end unless self.ecskc.nil?

    tally += 10.0 if self[:on_site]
    self[:total_due] = tally
  end

end
