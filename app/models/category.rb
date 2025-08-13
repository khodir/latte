class Category < ApplicationRecord
  self.table_name = "category"

  belongs_to :perusahaan
  has_many :item_category
  has_many :item, through: :item_category

  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  validates_presence_of :nama_category
  validates_uniqueness_of :nama_category, scope: :perusahaan_id
end
