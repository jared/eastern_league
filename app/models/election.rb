class Election < ActiveRecord::Base

  has_many :candidates
  has_many :users, :through => :candidates

  has_many :votes

end
