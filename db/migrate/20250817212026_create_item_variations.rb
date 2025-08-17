class CreateItemVariations < ActiveRecord::Migration[8.0]
  def change
    create_table :item_variation do |t|
      t.references :item, null: false, foreign_key: { to_table: :item, on_delete: :cascade }
      t.string :variation_name
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_index :item_variation, [ :item_id, :variation_name ], unique: true
  end
end
