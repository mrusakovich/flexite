class RemoveCreatedByColumnFromFlexiteConfigs < ActiveRecord::Migration
  def change
    remove_column :flexite_configs, :created_by, :integer
  end
end
