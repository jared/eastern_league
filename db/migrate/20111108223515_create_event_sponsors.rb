class CreateEventSponsors < ActiveRecord::Migration
  def change
    create_table :event_sponsors do |t|
      t.integer :event_id
      t.string  :name
      t.string  :link_type
      t.text    :url
      
      # Paperclip Fields
      t.string    :logo_file_name
      t.string    :logo_content_type
      t.integer   :logo_file_size
      t.datetime  :logo_updated_at
      
      t.timestamps
    end
  end
end
