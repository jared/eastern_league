class AddLunchesToRegistrations < ActiveRecord::Migration
  def change
    add_column :event_registrations, :saturday_lunches, :integer, :default => 0
    add_column :event_registrations, :sunday_lunches, :integer, :default => 0
  end
end
