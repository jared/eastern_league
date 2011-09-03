class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer  :user_id
      t.decimal  :amount,                         :precision => 8, :scale => 2
      t.string   :state,                          :default => "new"
      t.string   :paypal_status
      t.string   :paypal_transaction_identifier
      t.decimal  :paypal_fee,                     :precision => 8, :scale => 2
      t.text     :encrypted_data
      t.timestamps
    end
  end
end
