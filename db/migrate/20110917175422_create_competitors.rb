class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.integer :user_id
      t.boolean :pair, :default => false
      t.boolean :team, :default => false
      t.text :bio
      
      # Paperclip Fields
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at
      t.timestamps
    end
  end
end
