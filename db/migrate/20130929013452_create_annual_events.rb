class CreateAnnualEvents < ActiveRecord::Migration
  def change
    create_table :annual_events do |t|
      t.string :event_name
      t.integer :start_year
      t.integer :skip, :default => 0
      t.timestamps
    end
  end
end
