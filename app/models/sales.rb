class Sales < ApplicationRecord
  self.table_name = "sales"

  belongs_to :perusahaan
  belongs_to :customer, optional: true

  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  attribute :sales_date, :datetime, default: -> { Time.current }
  attribute :status, :string, default: "draft"
  attribute :total, :decimal, default: 0
  attribute :discount, :decimal, default: 0
  attribute :ppn, :decimal, default: 0

  validates_presence_of :nama_customer
  validates_inclusion_of :status, in: [ "draft", "paid", "unpaid" ]
  validates :total, :discount, :ppn, numericality: { greater_than_or_equal_to: 0 }
end
