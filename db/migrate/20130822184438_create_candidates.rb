class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :election_id
      t.integer :user_id
      t.timestamps
    end
  end
end
