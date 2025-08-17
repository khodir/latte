class Customer < ApplicationRecord
  self.table_name = "customer"

  belongs_to :perusahaan
  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  validates_presence_of :nama_customer
  validates_uniqueness_of :email, scope: :perusahaan_id, allow_blank: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true
end
