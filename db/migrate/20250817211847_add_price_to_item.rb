class AddPriceToItem < ActiveRecord::Migration[8.0]
  def change
    add_column :item, :price, :decimal, precision: 24, scale: 2
  end
end
