class CreateWildwoodRegistrations < ActiveRecord::Migration
  def change
    create_table :wildwood_registrations do |t|
      t.integer :season_id

      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :email
      t.string :phone

      t.boolean :judge, :default => false
      t.boolean :field_staff, :default => false
      t.boolean :sales, :default => false
      t.boolean :workshops, :default => false
      t.boolean :auction, :default => false
      t.boolean :operations, :default => false
      t.boolean :accepted_waiver, :default => false

      t.text :challenges
      t.text :ecskc

      t.boolean :on_site, :default => false
      t.integer :number_for_dinner

      t.decimal :total_due, :precision => 6, :scale => 2
      t.timestamps
    end
  end
end
