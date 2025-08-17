# Common Patterns and Templates for Latte Project

## Model Patterns

### Standard Model Template
```ruby

class ModelName < ApplicationRecord
  self.table_name = "table_name" if needed
  
  # Associations
  belongs_to :perusahaan
  has_many :related_models
  has_one_attached :image if applicable
  
  # Scopes
  scope :by_perusahaan, ->(perusahaan_id) { where(perusahaan_id: perusahaan_id) }
  
  # Validations
  validates_presence_of :required_field
  validates_uniqueness_of :unique_field, scope: :perusahaan_id
  
  # Custom methods
  def custom_method
    # Implementation
  end
  
  def as_json(options = {})
    super(options).merge({ custom_field: custom_method })
  end
end
```

### Join Table Model Pattern
```ruby

class JoinTableName < ApplicationRecord
  belongs_to :first_model
  belongs_to :second_model
  
  validates_uniqueness_of :first_model_id, scope: :second_model_id
end
```

## Controller Patterns

### Standard CRUD Controller Template
```ruby

class ModelController < ApplicationController
  # GET /path
  def show
    search_param[:per_page] ||= 9
    @data = Model.includes(:associations).by_perusahaan(@current_perusahaan.id)
    
    # Apply search filters
    if search_param[:q].present?
      @data = @data.where("field LIKE :q", { q: "%#{search_param[:q]}%" })
    end
    
    # Pagination
    total = @data.count
    @pagination = paginate(total)
    @data = @data.order(:field).limit(@pagination[:per_page]).offset(@pagination[:skip])
    
    render inertia: "path/show", props: {
      pagination: @pagination,
      data: @data.as_json(include: [:associations])
    }
  end
  
  # GET /path/new
  def new
    render inertia: "path/new", props: {}
  end
  
  # GET /path/edit/:id
  def edit
    @data = Model.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    render inertia: "path/edit", props: {
      data: @data.as_json
    }
  end
  
  # POST /path
  def create
    ApplicationRecord.transaction do
      @data = Model.new
      @data.assign_attributes(model_params)
      @data.perusahaan_id = @current_perusahaan.id
      @data.created_by = @current_user.email
      @data.save!
    end
    
    flash[:success] = "Model created successfully"
    redirect_to action: :show
  end
  
  # PUT /path/:id
  def update
    ApplicationRecord.transaction do
      @data = Model.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
      @data.assign_attributes(model_params)
      @data.updated_by = @current_user.email
      @data.save!
    end
    
    flash[:success] = "Model updated successfully"
    redirect_to action: :show
  end
  
  # DELETE /path/:id
  def destroy
    @data = Model.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    @data.destroy!
    
    flash[:success] = "Model deleted successfully"
    redirect_to search_param.merge(action: :show)
  end
  
  private
  
  def search_param
    params.permit(:q, :page, :per_page)
  end
  
  def model_params
    params.permit(:field1, :field2)
  end
end
```

## Vue.js Component Patterns

### List/Index Component Template
```vue
<template>
  <q-page padding>
    <div class="row q-mb-md">
      <div class="col">
        <h4 class="text-h4 q-my-none">Model List</h4>
      </div>
      <div class="col-auto">
        <q-btn 
          color="primary" 
          icon="add" 
          label="Add New"
          :to="{ name: 'model.new' }"
        />
      </div>
    </div>
    
    <!-- Search and Filters -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-gutter-md">
          <div class="col">
            <q-input
              v-model="searchForm.q"
              label="Search"
              outlined
              dense
              @keyup.enter="search"
            />
          </div>
          <div class="col-auto">
            <q-btn color="primary" @click="search">Search</q-btn>
          </div>
        </div>
      </q-card-section>
    </q-card>
    
    <!-- Data Table -->
    <q-table
      :rows="data"
      :columns="columns"
      row-key="id"
      :pagination="tablePagination"
      @request="onRequest"
    >
      <template v-slot:body-cell-actions="props">
        <q-td :props="props">
          <q-btn-group>
            <q-btn 
              size="sm" 
              color="primary" 
              icon="edit"
              :to="{ name: 'model.edit', params: { id: props.row.id } }"
            />
            <q-btn 
              size="sm" 
              color="negative" 
              icon="delete"
              @click="confirmDelete(props.row)"
            />
          </q-btn-group>
        </q-td>
      </template>
    </q-table>
  </q-page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { router } from '@inertiajs/vue3'

interface ModelData {
  id: number
  field1: string
  field2: string
}

interface Props {
  data: ModelData[]
  pagination: {
    current_page: number
    per_page: number
    total: number
  }
}

const props = defineProps<Props>()

const searchForm = ref({
  q: '',
  page: 1,
  per_page: 9
})

const columns = [
  { name: 'field1', label: 'Field 1', field: 'field1', align: 'left' },
  { name: 'field2', label: 'Field 2', field: 'field2', align: 'left' },
  { name: 'actions', label: 'Actions', field: 'actions', align: 'center' }
]

const tablePagination = computed(() => ({
  page: props.pagination.current_page,
  rowsPerPage: props.pagination.per_page,
  rowsNumber: props.pagination.total
}))

const search = () => {
  router.get(route('model.show'), searchForm.value)
}

const onRequest = (requestProp: any) => {
  searchForm.value.page = requestProp.pagination.page
  searchForm.value.per_page = requestProp.pagination.rowsPerPage
  search()
}

const confirmDelete = (item: ModelData) => {
  // Implement delete confirmation
}
</script>
```

### Form Component Template
```vue
<template>
  <q-page padding>
    <q-card>
      <q-card-section>
        <h5 class="text-h5 q-my-none">{{ isEdit ? 'Edit' : 'Add' }} Model</h5>
      </q-card-section>
      
      <q-form @submit="onSubmit">
        <q-card-section>
          <div class="row q-gutter-md">
            <div class="col-12 col-md-6">
              <q-input
                v-model="form.field1"
                label="Field 1"
                outlined
                :error="!!errors.field1"
                :error-message="errors.field1"
              />
            </div>
            <div class="col-12 col-md-6">
              <q-input
                v-model="form.field2"
                label="Field 2"
                outlined
                :error="!!errors.field2"
                :error-message="errors.field2"
              />
            </div>
          </div>
        </q-card-section>
        
        <q-card-actions align="right">
          <q-btn 
            flat 
            label="Cancel" 
            :to="{ name: 'model.show' }"
          />
          <q-btn 
            type="submit" 
            color="primary" 
            label="Save"
            :loading="form.processing"
          />
        </q-card-actions>
      </q-form>
    </q-card>
  </q-page>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useForm } from '@inertiajs/vue3'

interface ModelData {
  id?: number
  field1: string
  field2: string
}

interface Props {
  data?: ModelData
  errors?: Record<string, string>
}

const props = defineProps<Props>()

const isEdit = computed(() => !!props.data?.id)

const form = useForm({
  field1: props.data?.field1 || '',
  field2: props.data?.field2 || ''
})

const onSubmit = () => {
  if (isEdit.value) {
    form.put(route('model.update', props.data!.id))
  } else {
    form.post(route('model.create'))
  }
}
</script>
```

## Migration Patterns

### Standard Migration Template
```ruby
class CreateModelName < ActiveRecord::Migration[8.0]
  def change
    create_table :table_name do |t|
      t.references :perusahaan, null: false, foreign_key: true
      t.string :field1, null: false
      t.text :field2
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    
    add_index :table_name, [:perusahaan_id, :field1], unique: true
  end
end
```

### Join Table Migration Template
```ruby
class CreateJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :join_table_name do |t|
      t.references :first_model, null: false, foreign_key: true
      t.references :second_model, null: false, foreign_key: true
      t.string :created_by
      t.timestamps
    end
    
    add_index :join_table_name, [:first_model_id, :second_model_id], unique: true
  end
end
```

## Test Patterns

### Model Spec Template
```ruby
require 'rails_helper'

RSpec.describe ModelName, type: :model do
  let(:perusahaan) { create(:perusahaan) }
  
  describe 'associations' do
    it { should belong_to(:perusahaan) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:field1) }
    it { should validate_uniqueness_of(:field1).scoped_to(:perusahaan_id) }
  end
  
  describe 'scopes' do
    describe '.by_perusahaan' do
      it 'returns records for specific perusahaan' do
        # Test implementation
      end
    end
  end
end
```

### Controller Spec Template
```ruby
require 'rails_helper'

RSpec.describe ModelController, type: :controller do
  let(:user) { create(:user) }
  let(:perusahaan) { create(:perusahaan) }
  
  before do
    sign_in user
    allow(controller).to receive(:current_perusahaan).and_return(perusahaan)
  end
  
  describe 'GET #show' do
    it 'renders the show template' do
      get :show
      expect(response).to be_successful
    end
  end
  
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new record' do
        expect {
          post :create, params: { field1: 'value' }
        }.to change(ModelName, :count).by(1)
      end
    end
  end
end
```

## Route Patterns

### Standard Resource Routes
```ruby
# config/routes.rb
Rails.application.routes.draw do
  scope :master do
    get 'model', to: 'model#show'
    get 'model/new', to: 'model#new'
    get 'model/edit/:id', to: 'model#edit'
    post 'model', to: 'model#create'
    put 'model/:id', to: 'model#update'
    delete 'model/:id', to: 'model#destroy'
  end
end
```

## Common Helper Methods

### Pagination Helper
```ruby
def paginate(total)
  page = params[:page]&.to_i || 1
  per_page = params[:per_page]&.to_i || 10
  skip = (page - 1) * per_page
  
  {
    current_page: page,
    per_page: per_page,
    total: total,
    skip: skip,
    total_pages: (total.to_f / per_page).ceil
  }
end
```

### Search Helper
```ruby
def apply_search(query, search_term, fields)
  return query if search_term.blank?
  
  conditions = fields.map { |field| "#{field} LIKE :search" }.join(' OR ')
  query.where(conditions, search: "%#{search_term}%")
end
```
