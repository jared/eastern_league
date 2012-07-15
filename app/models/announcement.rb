class Announcement < ActiveRecord::Base

  validates_presence_of :body
  scope :recent, order("created_at DESC").limit(5)

end
