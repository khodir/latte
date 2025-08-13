class CreateItemCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :item_category do |t|
      t.references :item, null: false, foreign_key: { to_table: :item, on_delete: :cascade }
      t.references :category, null: false, foreign_key: { to_table: :category, on_delete: :cascade }
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_index :item_category, [ :item_id, :category_id ], unique: true
  end
end
