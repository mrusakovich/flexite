class CreateFlexiteEntries < ActiveRecord::Migration
  def change
    create_table :flexite_entries do |t|
      t.string :value
      t.string :type
      t.references :entry, polymorphic: true
      t.references :config

      t.timestamps
    end

    add_index :flexite_entries, :entry_id
  end
end
