class Candidate < ActiveRecord::Base

  belongs_to :user
  belongs_to :election

  has_and_belongs_to_many :votes

end
