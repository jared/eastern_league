class AddFreeBooleanToDisciplines < ActiveRecord::Migration
  def change
    add_column :disciplines, :free, :boolean, default: false
  end
end
