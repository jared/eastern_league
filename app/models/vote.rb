class Vote < ActiveRecord::Base

  belongs_to :election
  belongs_to :user
  has_and_belongs_to_many :candidates

  before_create :two_candidates

private

  def two_candidates
    unless candidate_ids.size == 2
      errors[:base] << "Please choose (only) two candidates"
      return false
    end
  end

end
