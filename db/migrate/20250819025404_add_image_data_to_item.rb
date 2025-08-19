class AddImageDataToItem < ActiveRecord::Migration[8.0]
  def change
    add_column :item, :image_data, :json
  end
end
