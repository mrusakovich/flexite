class CreateFlexiteConfigs < ActiveRecord::Migration
  def change
    create_table :flexite_configs do |t|
      t.string :name
      t.integer :created_by
      t.boolean :selectable, default: true
      t.references :config

      t.timestamps
    end

    add_index :flexite_configs, :config_id
  end
end
