class AddDefaultValueToScoresDisqualified < ActiveRecord::Migration
  def change
    change_column :scores, :disqualified, :boolean, :default => false
  end
end
