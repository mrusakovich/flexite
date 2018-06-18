class CreateFlexiteHistoryAttributes < ActiveRecord::Migration
  def change
    create_table :flexite_history_attributes do |t|
      t.references :history
      t.string :name
      t.string :value

      t.timestamps
    end

    add_index :flexite_history_attributes, :history_id
  end
end
