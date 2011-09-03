class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer   :user_id,             :null => false
      t.integer   :membership_plan_id,  :null => false
      t.datetime  :expires_at
      t.boolean   :primary_member,      :default => true
      t.integer   :primary_user_id
      t.boolean   :paid,                :default => false
      t.timestamps
    end
  end
end
