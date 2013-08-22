class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :name
      t.text   :description
      t.boolean :active, :default => true
      t.datetime :close_at

      t.timestamps
    end
  end
end
