class AnnualEvent < ActiveRecord::Base

  validates_presence_of :event_name
  validates_presence_of :start_year

  def annual_number
    (Time.now.year - self.start_year) + 1
  end

end
