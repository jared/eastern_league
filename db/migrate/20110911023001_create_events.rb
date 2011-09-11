class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string      :name
      t.integer     :organizer_id
      t.date        :start_date
      t.date        :end_date
      t.integer     :season_id
      t.string      :location
      t.string      :acronym
      t.string      :contact_name
      t.string      :contact_phone
      t.string      :contact_email
      t.string      :url
      t.string      :status
      t.boolean     :fee_received, :default => false
      t.boolean     :results_available, :default => false
      t.boolean     :online_registration, :default => true
      t.datetime    :registration_deadline
      t.timestamps
    end

    add_index :events, :season_id
    add_index :events, :start_date
  end
end
