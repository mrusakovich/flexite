class CreateFlexiteConfigs < ActiveRecord::Migration
  def change
    create_table :flexite_configs do |t|
      t.string :name
      t.integer :created_by
      t.references :parent, polymorphic: true

      t.timestamps
    end

    add_index :flexite_configs, :parent_id
    add_index :flexite_configs, :parent_type
  end
end
