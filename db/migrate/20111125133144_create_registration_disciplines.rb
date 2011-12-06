class CreateRegistrationDisciplines < ActiveRecord::Migration
  def change
    create_table :registration_disciplines do |t|
      t.integer :event_discipline_id
      t.integer :event_registration_id
      t.string  :group_name
      t.text    :group_members
      t.timestamps
    end
  end
end
