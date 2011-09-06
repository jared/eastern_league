class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.string      :name
      t.string      :abbreviation
      t.integer     :score_multiplier, :default => 1
      t.boolean     :active, :default => true
      t.integer     :position, :default => 1
      t.timestamps
    end
  end
end
