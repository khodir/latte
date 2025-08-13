require 'rails_helper'

RSpec.describe "Items", type: :request do
  fixtures :users, :perusahaans

  before(:each) {
    sign_in users(:admin), scope: :user
  }

  after(:each) {
    sign_out :user
  }

  describe "GET /master/item" do
    it "returns a successful response" do
      get url_for(controller: :item, action: :show)

      expect(response).to have_http_status(:success)
      expect(assigns(:pagination)).not_to be_nil

      pagination = assigns(:pagination)
      expect(pagination[:total]).to eq Item.count
    end
  end
end
