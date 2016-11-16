class EventSponsor < ActiveRecord::Base
  
  has_attached_file :logo, :styles => { :medium => "300x300^", :thumb => "100x100^"}
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/  
  
  belongs_to :event
  
end
