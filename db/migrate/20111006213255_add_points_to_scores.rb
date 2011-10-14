class AddPointsToScores < ActiveRecord::Migration
  def change
    change_table :scores do |t|
      t.integer :points, :default => 0
    end
  end
end
