class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :competitor_id
      t.integer :event_discipline_id
      t.decimal :score, :precision => 5, :scale => 2
      t.boolean :disqualified
      t.integer :rank
      t.string :tie_breaker
      t.timestamps
    end
  end
end
