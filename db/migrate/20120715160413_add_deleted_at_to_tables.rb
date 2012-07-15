class AddDeletedAtToTables < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime, :default => nil
    add_column :memberships, :deleted_at, :datetime, :default => nil
    add_column :orders, :deleted_at, :datetime, :default => nil
    add_column :line_items, :deleted_at, :datetime, :default => nil
  end
end
