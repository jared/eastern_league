class CreateMembershipPlans < ActiveRecord::Migration
  def change
    create_table :membership_plans do |t|
      t.string      :name
      t.decimal     :amount, :precision => 5, :scale => 2
      t.integer     :renewal_period
      t.boolean     :visible, :default => true
      t.boolean     :primary, :default => true
      t.timestamps
    end
  end
end
