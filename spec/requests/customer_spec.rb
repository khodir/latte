require 'rails_helper'

RSpec.describe "Customers", type: :request, inertia: true do
  fixtures :users, :perusahaans, :customers

  let(:current_user) { users(:admin) }
  let(:current_perusahaan) { perusahaans(:default) }

  before(:each) do
    sign_in current_user, scope: :user
  end

  after(:each) do
    sign_out :user
  end

  describe "GET /master/customer" do
    it "should return a successful response" do
      # setup
      get url_for(controller: :customer, action: :show)
      expect(response).to have_http_status(:success)

      # data
      pagination = assigns(:pagination)
      data = assigns(:data)

      expect(pagination).not_to be_nil
      expect(data).not_to be_nil

      expect(pagination[:total]).to eq(Customer.by_perusahaan(current_perusahaan.id).count)
      expect(data.pluck(:perusahaan_id).uniq).to match_array([ current_perusahaan.id ])

      # inertia
      expect(inertia).to render_component("master/customer/show")
      expect(inertia).to include_props({ pagination: pagination, data: data.as_json })
    end
  end

  describe "GET /master/customer/new" do
    it "should return a successful response" do
      get url_for(controller: :customer, action: :new)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /master/customer/edit/:id" do
    it "should return a successful response" do
      # setup
      customer = customers(:john_doe)
      get url_for(controller: :customer, action: :edit, id: customer.id)
      expect(response).to have_http_status(:success)

      # data
      expect(assigns(:data)).to eq(customer)

      # inertia
      expect(inertia).to render_component("master/customer/edit")
      expect(inertia).to include_props({ data: customer.as_json })
    end
  end

  describe "POST /master/customer" do
    it "should create a new customer" do
      # setup
      req = {
        nama_customer: Faker::Name.name,
        email: Faker::Internet.email,
        no_telp: Faker::PhoneNumber.phone_number,
        alamat: Faker::Address.full_address
      }

      post url_for(controller: :customer, action: :create), params: req
      expect(response).to have_http_status(:redirect)

      # data
      customer = assigns(:data)
      expect(customer).to be_a(Customer)
      expect(customer.as_json).to include(req.as_json)
      expect(customer.perusahaan_id).to eq(current_perusahaan.id)
      expect(customer.previously_new_record?).to eq(true)
    end
  end

  describe "PUT /master/customer/:id" do
    it "should update existing customer" do
      # setup
      customer = customers(:jane_smith)
      req = {
        nama_customer: Faker::Name.name,
        email: Faker::Internet.email,
        no_telp: Faker::PhoneNumber.phone_number,
        alamat: Faker::Address.full_address
      }

      put url_for(controller: :customer, action: :update, id: customer.id), params: req
      expect(response).to have_http_status(:redirect)

      # data
      customer.reload
      updated = assigns(:data)

      expect(updated).to eq(customer)
      expect(customer.as_json).to include(req.as_json)
    end
  end

  describe "DELETE /master/customer/:id" do
    it "should destroy customer" do
      # setup
      customer = customers(:alice_brown)
      delete url_for(controller: :customer, action: :destroy, id: customer.id)
      expect(response).to have_http_status(:redirect)

      # data
      destroyed = assigns(:data)
      expect(destroyed).to eq(customer)
      expect(destroyed.destroyed?).to eq(true)
    end
  end
end
