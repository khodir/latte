# typed: true

class Customer < ApplicationRecord
  extend T::Sig

  belongs_to :perusahaan

  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }

  sig { params(perusahaan_id: Integer).returns(ActiveRecord::Relation) }
  def self.by_perusahaan(perusahaan_id)
    where(perusahaan_id: perusahaan_id)
  end

  validates_presence_of :nama_customer
  validates_uniqueness_of :email, scope: :perusahaan_id, allow_blank: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true

  def as_json(options = {})
    super(options)
  end
end
