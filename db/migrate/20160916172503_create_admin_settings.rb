class CreateAdminSettings < ActiveRecord::Migration
  def change
    create_table :admin_settings do |t|
      t.string  :jacket_season, default: '2016'
      t.text    :jacket_description
      t.decimal :raffle_ticket_cost, precision: 5, scale: 2, default: 5.0
      t.boolean :raffle_open, default: false
      t.string  :raffle_item_name
      t.integer :raffle_tickets_available, default: 50
      t.integer :raffle_tickets_per_user, default: 10
      t.text    :raffle_item_description
      t.integer :commissioner_user_id, default: 621
      t.timestamps null: false
    end

    AdminSetting.create(jacket_season: '2016', raffle_ticket_cost: 5, commissioner_user_id: 621)

  end
end
