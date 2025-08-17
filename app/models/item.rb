class Item < ApplicationRecord
  self.table_name = "item"

  belongs_to :perusahaan
  has_many :item_category
  has_many :category, through: :item_category
  has_one_attached :image

  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  attribute :price, :decimal, default: 0

  validates_presence_of :kode_item, :nama_item
  validates_uniqueness_of :kode_item, scope: :perusahaan_id
  validates_numericality_of :price, greater_than_or_equal_to: 0

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if image.attached?
  end

  def as_json(options = {})
    super(options).merge({ image_url: self.image_url })
  end
end
