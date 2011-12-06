class EventRegistration < ActiveRecord::Base
  
  belongs_to :competitor
  belongs_to :event

  has_many :registration_disciplines, :dependent => :destroy
  
end
