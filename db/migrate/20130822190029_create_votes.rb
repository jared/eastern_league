class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :election_id
      t.integer :user_id
      t.timestamps
    end

    create_table :candidates_votes, :id => false do |t|
      t.integer :candidate_id
      t.integer :vote_id
    end

  end
end
