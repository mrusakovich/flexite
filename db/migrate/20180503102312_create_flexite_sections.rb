class CreateFlexiteSections < ActiveRecord::Migration
  def change
    create_table :flexite_sections do |t|
      t.string :name
      t.timestamps
    end

    add_index :flexite_sections, :parent_id
  end
end
