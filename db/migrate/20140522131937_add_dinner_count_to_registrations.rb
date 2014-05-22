class AddDinnerCountToRegistrations < ActiveRecord::Migration
  def change
    add_column :event_registrations, :number_for_dinner, :integer, :default => 0
  end
end
