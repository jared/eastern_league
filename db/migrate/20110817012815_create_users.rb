class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # Authlogic "meat & potatoes"
      t.string      :email,               :null => false
      t.string      :crypted_password,    :null => false
      t.string      :password_salt,       :null => false
      t.string      :persistence_token,   :null => false
      t.string      :single_access_token, :null => false
      t.string      :perishable_token,    :null => false

      # Housekeeping
      t.integer     :login_count,         :null => false, :default => 0
      t.integer     :failed_login_count,  :null => false, :default => 0
      t.datetime    :last_request_at
      t.datetime    :current_login_at
      t.datetime    :last_login_at
      t.string      :current_login_ip
      t.string      :last_login_ip

      # Legacy Fields
      t.string      :last_name
      t.string      :first_name
      t.string      :full_name
      t.string      :mailing_name
      t.string      :additional_members

      t.string      :store_affiliation
      t.string      :street_address_1
      t.string      :street_address_2
      t.string      :city
      t.string      :state
      t.string      :zip
      t.string      :phone_number

      t.boolean     :admin,             :default => false
      t.boolean     :el_member,         :default => false
      t.boolean     :board_member,      :default => false
      t.boolean     :lifetime,          :default => false

      t.integer     :current_through_month
      t.integer     :current_through_year

      t.text        :notes

      t.datetime    :member_since

      t.boolean     :former_member,     :default => false

      t.timestamps
    end
  end
end
