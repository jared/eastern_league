class AddPrivacyFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :share_email, :boolean, :default => false
    add_column :users, :share_phone, :boolean, :default => false
    add_column :users, :share_address, :boolean, :default => false
  end
end
