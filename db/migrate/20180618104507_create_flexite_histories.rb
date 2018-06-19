class CreateFlexiteHistories < ActiveRecord::Migration
  def change
    create_table :flexite_histories do |t|
      t.references :entity, polymorphic: true

      t.timestamps
    end

    add_index :flexite_histories, :entity_id
    add_index :flexite_histories, :entity_type
  end
end
