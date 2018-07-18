class AddDescriptionColumnToFlexiteConfigs < ActiveRecord::Migration
  def change
    add_column :flexite_configs, :description, :string
  end
end
