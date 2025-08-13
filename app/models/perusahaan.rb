class Perusahaan < ApplicationRecord
  self.table_name = "perusahaan"

  belongs_to :user

  validates_presence_of :nama_perusahaan
end
