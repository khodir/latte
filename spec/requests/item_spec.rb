require 'rails_helper'

RSpec.describe "Items", type: :request do
  fixtures :users, :perusahaans, :categories, :items

  let(:current_user) { users(:admin) }
  let(:current_perusahaan) { perusahaans(:default) }

  before(:each) do
    sign_in current_user, scope: :user
  end

  after(:each) do
    sign_out :user
  end

  describe "GET /master/item" do
    it "returns a successful response" do
      get url_for(controller: :item, action: :show)

      expect(response).to have_http_status(:success)
      expect(assigns(:pagination)).not_to be_nil
      expect(assigns(:categories)).not_to be_nil
      expect(assigns(:data)).not_to be_nil

      pagination = assigns(:pagination)
      expect(pagination[:total]).to eq(Item.by_perusahaan(current_perusahaan.id).count)
    end
  end

  describe "GET /master/item/new" do
    it "returns a successful response" do
      get url_for(controller: :item, action: :new)

      expect(response).to have_http_status(:success)
      expect(assigns(:categories)).not_to be_nil
    end
  end

  describe "GET /master/item/edit/:id" do
    it "returns a successful response" do
      get url_for(controller: :item, action: :edit, id: items(:espresso).id)

      expect(response).to have_http_status(:success)
      expect(assigns(:categories)).not_to be_nil
      expect(assigns(:data)).not_to be_nil
      expect(assigns(:data)).to eq(items(:espresso))
    end
  end

  describe "POST /master/item" do
    it "creates a new item successfully" do
      image_file = fixture_file_upload('test_image.jpg', 'image/jpeg')
      item_params = {
        kode_item: "TEST-001",
        nama_item: "Test Item",
        keterangan: "Test description",
        image: image_file,
        item_category_attributes: [
          { category_id: categories(:makanan).id },
          { category_id: categories(:minuman).id }
        ],
        item_variation_attributes: [
          {
            variation_name: "Variation-001",
            item_variation_value_attributes: [
              { variation_value: "Value-001", additional_price: 1000 },
              { variation_value: "Value-002", additional_price: 2000 }
            ]
          }
        ]
      }

      expect {
        post url_for(controller: :item, action: :create), params: item_params
      }.to change(Item, :count).by(1)

      expect(response).to have_http_status(:redirect)

      item = assigns(:data)

      # item
      expect(item).to be_a(Item)
      expect(item.perusahaan_id).to eq(current_perusahaan.id)
      expect(item.created_by).to eq(current_user.email)
      expect(item.as_json).to include(item_params.as_json(only: [ :kode_item, :nama_item, :keterangan ]))

      # item category
      expect(item.category.pluck(:id)).to match_array([ categories(:makanan).id, categories(:minuman).id ])

      # item variation
      expect(item.item_variation.pluck(:variation_name)).to match_array([ "Variation-001" ])
      expect(item.item_variation.first.item_variation_value.pluck(:variation_value)).to match_array([ "Value-001", "Value-002" ])

      # item image
      expect(item.image).to be_attached
      expect(item.image.filename).to eq('test_image.jpg')
    end
  end

  describe "PUT /master/item/:id" do
    it "updates existing item successfully" do
      item = items(:cappuccino)
      image_file = fixture_file_upload('test_image.jpg', 'image/jpeg')
      update_params = {
        kode_item: "UPDATED-001",
        nama_item: "Updated Test Item",
        image: image_file,
        delete_image: 1,
        item_category_attributes: [
          { category_id: categories(:minuman).id }
        ],
        item_variation_attributes: [
          {
            variation_name: "Variation-002",
            item_variation_value_attributes: [
              { variation_value: "Value-003", additional_price: 1000 },
              { variation_value: "Value-004", additional_price: 2000 }
            ]
          }
        ]
      }

      put url_for(controller: :item, action: :update, id: items(:cappuccino).id), params: update_params
      expect(response).to have_http_status(:redirect)

      item.reload
      updated_item = assigns(:data)

      # item
      expect(updated_item).to be_a(Item)
      expect(updated_item).to eq(item)
      expect(updated_item.as_json).to include(update_params.as_json(only: [ :kode_item, :nama_item ]))

      # item category
      expect(item.category.pluck(:id)).to match_array([ categories(:minuman).id ])

      # item variation
      expect(item.item_variation.pluck(:variation_name)).to match_array([ "Variation-002" ])
      expect(item.item_variation.first.item_variation_value.pluck(:variation_value)).to match_array([ "Value-003", "Value-004" ])

      # item image
      expect(updated_item.image).to be_attached
      expect(updated_item.image.filename).to eq('test_image.jpg')
    end
  end

  describe "DELETE /master/item/:id" do
    it "destroys item successfully" do
      expect {
        delete url_for(controller: :item, action: :destroy, id: items(:croissant).id)
      }.to change(Item, :count).by(-1)

      expect(response).to have_http_status(:redirect)

      destroyed_item = assigns(:data)
      expect(destroyed_item).to eq(items(:croissant))
      expect(destroyed_item.destroyed?).to eq(true)
    end
  end
end
