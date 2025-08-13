class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :category do |t|
      t.references :perusahaan, null: false, foreign_key: { to_table: :perusahaan, on_delete: :restrict }
      t.string :nama_category, null: false
      t.string :keterangan
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_index :category, [ :perusahaan_id, :nama_category ], unique: true
  end
end
