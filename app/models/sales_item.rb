class SalesItem < ApplicationRecord
  self.table_name = "sales_item"

  belongs_to :sales
  belongs_to :item

  attribute :quantity, :decimal, default: 0
  attribute :base_price, :decimal, default: 0
  attribute :additional_price, :decimal, default: 0
  attribute :total_price, :decimal, default: 0

  validates :quantity, :base_price, :additional_price, :total_price, numericality: { greater_than_or_equal_to: 0 }
end
