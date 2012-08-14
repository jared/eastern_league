class CreateJackets < ActiveRecord::Migration
  def change
    create_table :jackets do |t|
      t.string :name
      t.string :style
      t.string :size
      t.string :typeface
      t.integer :season_id
      t.boolean :delivery
      t.decimal :price, :precision => 4, :scale => 2
      t.string :custom_text_1
      t.string :custom_text_2
      t.string :custom_text_3
      t.timestamps
    end
  end
end
