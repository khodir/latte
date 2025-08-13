class CreatePerusahaans < ActiveRecord::Migration[8.0]
  def change
    create_table :perusahaan do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nama_perusahaan, null: false
      t.string :alamat
      t.string :no_telepon
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end

    add_index :perusahaan, :nama_perusahaan
  end
end
