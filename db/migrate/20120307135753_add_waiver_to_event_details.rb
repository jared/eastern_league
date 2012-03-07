class AddWaiverToEventDetails < ActiveRecord::Migration
  def change
    add_column :event_details, :waiver, :text
  end
end
