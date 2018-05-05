class CreateFlexiteConfigs < ActiveRecord::Migration
  def change
    create_table :flexite_configs do |t|
      t.string :name
      t.integer :created_by
      t.references :section

      t.timestamps
    end

    add_index :flexite_configs, :entry_id
  end
end
