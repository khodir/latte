class ItemVariationValue < ApplicationRecord
  self.table_name = "item_variation_value"

  belongs_to :item_variation

  attribute :additional_price, :decimal, default: 0

  validates_presence_of :variation_value
  validates_numericality_of :additional_price, greater_than_or_equal_to: 0
end
