class ItemVariation < ApplicationRecord
  self.table_name = "item_variation"

  belongs_to :item
  has_many :item_variation_value

  accepts_nested_attributes_for :item_variation_value, allow_destroy: true

  validates_presence_of :variation_name
  validates_uniqueness_of :variation_name, scope: :item_id
end
