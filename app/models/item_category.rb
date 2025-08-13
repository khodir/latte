class ItemCategory < ApplicationRecord
  self.table_name = "item_category"

  belongs_to :item
  belongs_to :category

  validates_presence_of :item_id, :category_id
  validates_uniqueness_of :category_id, scope: :item_id
end
