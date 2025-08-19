class Item < ApplicationRecord
  include ItemImageUploader::Attachment(:image)

  self.table_name = "item"

  belongs_to :perusahaan
  has_many :item_category
  has_many :category, through: :item_category
  has_many :item_variation

  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  accepts_nested_attributes_for :item_category, allow_destroy: true
  accepts_nested_attributes_for :item_variation, allow_destroy: true

  attribute :price, :decimal, default: 0

  validates_presence_of :kode_item, :nama_item
  validates_uniqueness_of :kode_item, scope: :perusahaan_id
  validates_numericality_of :price, greater_than_or_equal_to: 0

  def as_json(options = {})
    super(options)
      .merge({ image_url: self.image.nil? ? nil : self.image.download_url })
      .except("image_data")
  end
end
