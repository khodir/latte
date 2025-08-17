class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customer do |t|
      t.references :perusahaan, null: false, foreign_key: { to_table: :perusahaan }
      t.string :nama_customer, null: false
      t.string :email
      t.string :no_telp
      t.text :alamat
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end

    add_index :customer, [ :perusahaan_id, :nama_customer ]
    add_index :customer, [ :perusahaan_id, :email ], unique: true
  end
end
