class AddRegistrationInstructionsToEventDetails < ActiveRecord::Migration
  def change
    add_column :event_details, :registration_instructions, :text
  end
end
