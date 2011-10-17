class AddSeasonToScore < ActiveRecord::Migration
  def change
    add_column :scores, :season_id, :integer
    Score.update_all "season_id = 17"
  end
end
