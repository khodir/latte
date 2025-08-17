class CreateItemVariationValues < ActiveRecord::Migration[8.0]
  def change
    create_table :item_variation_value do |t|
      t.references :item_variation, null: false, foreign_key: { to_table: :item_variation, on_delete: :cascade }
      t.string :variation_value
      t.decimal :additional_price, precision: 24, scale: 2
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_index :item_variation_value, [ :item_variation_id, :variation_value ], unique: true
  end
end
