class AddValidMemberFieldToScores < ActiveRecord::Migration
  def change
    add_column :scores, :current_member, :boolean, :default => true
  end
end
