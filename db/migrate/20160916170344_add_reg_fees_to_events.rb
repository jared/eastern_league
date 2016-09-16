class AddRegFeesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :flat_rate, :decimal, precision: 5, scale: 2, default: nil
    add_column :events, :base_rate, :decimal, precision: 5, scale: 2, default: 10.00
    add_column :events, :discipline_rate, :decimal, precision: 5, scale: 2, default: 10.00
  end
end
