class CreateFlexiteEntries < ActiveRecord::Migration
  def change
    create_table :flexite_entries do |t|
      t.string :value
      t.string :type
      t.references :parent, polymorphic: true

      t.timestamps
    end

    add_index :flexite_entries, :parent_id
  end
end
