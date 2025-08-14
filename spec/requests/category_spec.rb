require 'rails_helper'

RSpec.describe "Categories", type: :request, inertia: true do
  fixtures :users, :perusahaans, :categories

  let (:current_user) { users(:admin) }
  let (:current_perusahaan) { perusahaans(:default) }

  before(:each) {
    sign_in current_user, scope: :user
  }

  after(:each) {
    sign_out :user
  }

  describe "GET /master/category" do
    it "should return a successful response" do
      # setup
      get url_for(controller: :category, action: :show)
      expect(response).to have_http_status(:success)

      # data
      pagination = assigns(:pagination)
      data = assigns(:data)

      expect(pagination).not_to be_nil
      expect(data).not_to be_nil

      expect(pagination[:total]).to eq(Category.by_perusahaan(current_perusahaan.id).count)
      expect(data.pluck(:perusahaan_id).uniq).to match_array([ current_perusahaan.id ])

      # inertia
      expect(inertia).to render_component("master/category/show")
      expect(inertia).to include_props({ pagination: pagination, data: data })
    end
  end

  describe "GET /master/category/new" do
    it "should return a successful response" do
      get url_for(controller: :category, action: :new)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /master/category/edit/:id" do
    it "should return a successful response" do
      # setup
      category = categories(:makanan)
      get url_for(controller: :category, action: :edit, id: category.id)
      expect(response).to have_http_status(:success)

      # data
      expect(assigns(:data)).to eq(category)

      # inertia
      expect(inertia).to render_component("master/category/edit")
      expect(inertia).to include_props({ data: category })
    end
  end

  describe "POST /master/category" do
    it "should create a new category" do
      # setup
      req = {
        nama_category: Faker::Number.numerify("CAT-#####"),
        keterangan: Faker::Lorem.sentence(word_count: 5)
      }

      post url_for(controller: :category, action: :create), params: req
      expect(response).to have_http_status(:redirect)

      # data
      category = assigns(:data)
      expect(category).to be_a(Category)
      expect(category.as_json).to include(req.as_json)
      expect(category.perusahaan_id).to eq(current_perusahaan.id)
      expect(category.previously_new_record?).to eq(true)
    end
  end

  describe "PUT /master/category/:id" do
    it "should update existing category" do
      # setup
      category = categories(:minuman)
      req = {
        nama_category: Faker::Number.numerify("CAT-#####"),
        keterangan: Faker::Lorem.sentence(word_count: 5)
      }

      put url_for(controller: :category, action: :update, id: category.id), params: req
      expect(response).to have_http_status(:redirect)

      # data
      category.reload
      updated = assigns(:data)

      expect(updated).to eq(category)
      expect(category.as_json).to include(req.as_json)
    end
  end

  describe "DELETE /master/category/:id" do
    it "should destroy category" do
      # setup
      category = categories(:coffe_based)
      delete url_for(controller: :category, action: :destroy, id: category.id)
      expect(response).to have_http_status(:redirect)

      # data
      destroyed = assigns(:data)
      expect(destroyed).to eq(category)
      expect(destroyed.destroyed?).to eq(true)
    end
  end
end
