class EventRegistration < ActiveRecord::Base
  
  belongs_to :competitor
  belongs_to :event

  has_one :line_item, :as => :purchasable

  has_many :registration_disciplines, :dependent => :destroy
  has_many :event_disciplines, :through => :registration_disciplines
  has_many :disciplines, :through => :event_disciplines
  
end
