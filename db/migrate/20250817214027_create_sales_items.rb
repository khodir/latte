class CreateSalesItems < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_item do |t|
      t.references :sales, null: false, foreign_key: { to_table: :sales, on_delete: :restrict }
      t.references :item, null: false, foreign_key: { to_table: :item, on_delete: :restrict }
      t.decimal :quantity, precision: 24, scale: 2
      t.decimal :base_price, precision: 24, scale: 2
      t.decimal :additional_price, precision: 24, scale: 2
      t.decimal :total_price, precision: 24, scale: 2
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
