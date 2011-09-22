class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :competitor_id
      t.integer :team_id
      t.boolean :captain, :default => false
      t.boolean :sub,     :default => false
      t.timestamps
    end
  end
end
