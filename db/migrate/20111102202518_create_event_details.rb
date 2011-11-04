class CreateEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details do |t|
      t.integer :event_id
      t.text    :general_information
      t.text    :competitor_information
      t.text    :directions
      t.text    :accommodations
      t.text    :banquet
      t.text    :auction
      t.text    :sponsors
      t.text    :schedule
      t.timestamps
    end
  end
end
