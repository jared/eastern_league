class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer     :order_id
      t.integer     :purchasable_id
      t.string      :purchasable_type
      t.decimal     :amount, :precision => 8, :scale => 2
      t.string      :description
      t.timestamps
    end
  end
end
