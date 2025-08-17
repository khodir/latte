class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.bigint :perusahaan_id, null: false
      t.references :customer, null: true, foreign_key: { to_table: :customer, on_delete: :restrict }
      t.string :nama_customer
      t.timestamp :sales_date
      t.string :status
      t.decimal :total, precision: 24, scale: 2
      t.decimal :discount, precision: 24, scale: 2
      t.decimal :ppn, precision: 24, scale: 2
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_foreign_key :sales, :perusahaan, column: :perusahaan_id, on_delete: :restrict
    add_index :sales, :nama_customer
    add_index :sales, :sales_date
    add_index :sales, :status
  end
end
