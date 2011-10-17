class AddCurrentThroughDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_through_date, :date
  end
end
