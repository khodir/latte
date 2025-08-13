class Item < ApplicationRecord
  self.table_name = "item"

  belongs_to :perusahaan
  has_many :item_category
  has_many :category, through: :item_category
  has_one_attached :image

  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  validates_presence_of :kode_item, :nama_item
  validates_uniqueness_of :kode_item, scope: :perusahaan_id
end
