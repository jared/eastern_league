class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :competitor_id
      t.integer :season_id
      t.integer :discipline_id
      t.integer :points
      t.integer :rank
      t.integer :competition_count
      t.string :tie_breaker
      t.timestamps
    end
  end
end
