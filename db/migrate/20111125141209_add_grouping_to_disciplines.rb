class AddGroupingToDisciplines < ActiveRecord::Migration
  def change
    add_column :disciplines, :discipline_group, :string
  end
end
