class CreateEventDisciplines < ActiveRecord::Migration
  def change
    create_table :event_disciplines do |t|
      t.integer :event_id
      t.integer :discipline_id
      t.timestamps
    end
  end
end
