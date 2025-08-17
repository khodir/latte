<template>
  <q-page padding>
    <div class="row q-mb-md">
      <div class="col">
        <h4 class="text-h4 q-my-none">Customer List</h4>
      </div>
      <div class="col-auto">
        <q-btn 
          color="primary" 
          icon="add" 
          label="Add Customer"
          :to="{ name: 'customer.new' }"
        />
      </div>
    </div>
    
    <!-- Search -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-gutter-md">
          <div class="col">
            <q-input
              v-model="searchForm.q"
              label="Search customers..."
              outlined
              dense
              placeholder="Search by name, email, or phone"
              @keyup.enter="search"
            />
          </div>
          <div class="col-auto">
            <q-btn color="primary" @click="search">Search</q-btn>
            <q-btn flat @click="clearSearch" class="q-ml-sm">Clear</q-btn>
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
      :loading="loading"
    >
      <template v-slot:body-cell-actions="props">
        <q-td :props="props">
          <q-btn-group>
            <q-btn 
              size="sm" 
              color="primary" 
              icon="edit"
              :to="{ name: 'customer.edit', params: { id: props.row.id } }"
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
    
    <!-- Delete Confirmation Dialog -->
    <q-dialog v-model="deleteDialog">
      <q-card>
        <q-card-section>
          <div class="text-h6">Confirm Delete</div>
        </q-card-section>
        <q-card-section>
          Are you sure you want to delete customer "{{ selectedCustomer?.nama_customer }}"?
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" @click="deleteDialog = false" />
          <q-btn color="negative" label="Delete" @click="deleteCustomer" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { router } from '@inertiajs/vue3'

interface CustomerData {
  id: number
  nama_customer: string
  email?: string
  no_telp?: string
  alamat?: string
  created_at: string
  updated_at: string
}

interface Props {
  data: CustomerData[]
  pagination: {
    current_page: number
    per_page: number
    total: number
  }
}

const props = defineProps<Props>()

const loading = ref(false)
const deleteDialog = ref(false)
const selectedCustomer = ref<CustomerData | null>(null)

const searchForm = ref({
  q: '',
  page: 1,
  per_page: 9
})

const columns = [
  { 
    name: 'nama_customer', 
    label: 'Customer Name', 
    field: 'nama_customer', 
    align: 'left' as const,
    sortable: true
  },
  { 
    name: 'email', 
    label: 'Email', 
    field: 'email', 
    align: 'left' as const
  },
  { 
    name: 'no_telp', 
    label: 'Phone', 
    field: 'no_telp', 
    align: 'left' as const
  },
  { 
    name: 'alamat', 
    label: 'Address', 
    field: 'alamat', 
    align: 'left' as const
  },
  { 
    name: 'actions', 
    label: 'Actions', 
    field: 'actions', 
    align: 'center' as const
  }
]

const tablePagination = computed(() => ({
  page: props.pagination.current_page,
  rowsPerPage: props.pagination.per_page,
  rowsNumber: props.pagination.total
}))

const search = () => {
  loading.value = true
  router.get('/master/customer', searchForm.value, {
    onFinish: () => loading.value = false
  })
}

const clearSearch = () => {
  searchForm.value.q = ''
  search()
}

const onRequest = (requestProp: any) => {
  searchForm.value.page = requestProp.pagination.page
  searchForm.value.per_page = requestProp.pagination.rowsPerPage
  search()
}

const confirmDelete = (customer: CustomerData) => {
  selectedCustomer.value = customer
  deleteDialog.value = true
}

const deleteCustomer = () => {
  if (selectedCustomer.value) {
    router.delete(`/master/customer/${selectedCustomer.value.id}`, {
      onSuccess: () => {
        deleteDialog.value = false
        selectedCustomer.value = null
      }
    })
  }
}
</script>
