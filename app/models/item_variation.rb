class ItemVariation < ApplicationRecord
  self.table_name = "item_variation"

  belongs_to :item
  has_many :item_variation_value

  validates_presence_of :variation_name
end
