class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.integer :competitor_id
      t.integer :event_id
      t.decimal :amount,                :precision => 7, :scale => 2
      t.boolean :paid,                  :default => false
      t.boolean :first_time_competitor, :default => false
      t.boolean :accepted_terms,        :default => false
      t.timestamps
    end
    
  end
end
