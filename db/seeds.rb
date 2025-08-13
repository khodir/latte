# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ApplicationRecord.transaction do
  # user
  @user = User.find_or_create_by!(email: "admin@example.com") do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end

  # perusahaan
  @perusahaan = Perusahaan.find_or_create_by!(user_id: @user.id) do |perusahaan|
    perusahaan.nama_perusahaan = Faker::Company.unique.name
  end

  # category
  @categories = []
  categories = %w[makanan minuman coffee-based milk-based snacks]
  categories.each do |category_name|
    @categories << Category.find_or_create_by!(perusahaan_id: @perusahaan.id, nama_category: category_name) do |category|
      category.keterangan = Faker::Lorem.sentence
    end
  end

  # items
  if Item.count <= 0
    @categories.each do |category|
      rand(10..20).times do
        item = Item.create!(
          perusahaan_id: @perusahaan.id,
          kode_item: Faker::Number.numerify("ITM-######"),
          nama_item: Faker::Food.dish,
          keterangan: Faker::Lorem.sentence
        )

        ItemCategory.create!(category_id: category.id, item_id: item.id)
      end
    end
  end
end
