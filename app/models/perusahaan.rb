class Perusahaan < ApplicationRecord
  self.table_name = "perusahaan"

  belongs_to :user
  has_many :items, class_name: "Item"
  has_many :categories, class_name: "Category"
  has_many :customers, class_name: "Customer"

  validates_presence_of :nama_perusahaan
end
