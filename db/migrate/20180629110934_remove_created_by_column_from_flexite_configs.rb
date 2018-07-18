class RemoveCreatedByColumnFromFlexiteConfigs < ActiveRecord::Migration
  def up
    remove_column :flexite_configs, :created_by
  end

  def down
    add_column :flexite_configs, :created_by, :integer
  end
end
