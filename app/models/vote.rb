class Vote < ActiveRecord::Base

  belongs_to :election
  belongs_to :user
  has_and_belongs_to_many :candidates

  validate :two_candidates

private

  def two_candidates  
    errors[:base] << "Please choose (only) two candidates" unless candidate_ids.size == 2
  end

end
