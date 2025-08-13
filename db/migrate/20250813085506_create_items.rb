class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :item do |t|
      t.references :perusahaan, null: false, foreign_key: { to_table: :perusahaan, on_delete: :restrict }
      t.string :kode_item, null: false
      t.string :nama_item, null: false
      t.string :keterangan
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_index :item, [ :perusahaan_id, :kode_item ], unique: true
    add_index :item, :nama_item
  end
end
