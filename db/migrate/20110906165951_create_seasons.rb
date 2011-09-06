class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string  :year
      t.date    :start_date
      t.date    :end_date
      t.boolean :current, :default => false
      t.timestamps
    end
  end
end
