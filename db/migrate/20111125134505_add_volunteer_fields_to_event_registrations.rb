class AddVolunteerFieldsToEventRegistrations < ActiveRecord::Migration
  def change
    add_column :event_registrations, :volunteer_judge,        :boolean, :default => false
    add_column :event_registrations, :volunteer_field_staff,  :boolean, :default => false
    add_column :event_registrations, :volunteer_setup_crew,   :boolean, :default => false
        
    
  end
end
