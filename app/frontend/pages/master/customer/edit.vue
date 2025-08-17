<template>
  <q-page padding>
    <q-card>
      <q-card-section>
        <h5 class="text-h5 q-my-none">Edit Customer</h5>
      </q-card-section>
      
      <q-form @submit="onSubmit">
        <q-card-section>
          <div class="row q-gutter-md">
            <div class="col-12 col-md-6">
              <q-input
                v-model="form.nama_customer"
                label="Customer Name *"
                outlined
                :error="!!props.errors?.nama_customer"
                :error-message="props.errors?.nama_customer"
              />
            </div>
            <div class="col-12 col-md-6">
              <q-input
                v-model="form.email"
                label="Email"
                type="email"
                outlined
                :error="!!props.errors?.email"
                :error-message="props.errors?.email"
              />
            </div>
            <div class="col-12 col-md-6">
              <q-input
                v-model="form.no_telp"
                label="Phone Number"
                outlined
                :error="!!props.errors?.no_telp"
                :error-message="props.errors?.no_telp"
              />
            </div>
            <div class="col-12">
              <q-input
                v-model="form.alamat"
                label="Address"
                type="textarea"
                rows="3"
                outlined
                :error="!!props.errors?.alamat"
                :error-message="props.errors?.alamat"
              />
            </div>
          </div>
        </q-card-section>
        
        <q-card-actions align="right">
          <q-btn 
            flat 
            label="Cancel" 
            :to="{ name: 'customer.show' }"
          />
          <q-btn 
            type="submit" 
            color="primary" 
            label="Update Customer"
            :loading="form.processing"
          />
        </q-card-actions>
      </q-form>
    </q-card>
  </q-page>
</template>

<script setup lang="ts">
import { useForm } from '@inertiajs/vue3'

interface CustomerData {
  id: number
  nama_customer: string
  email?: string
  no_telp?: string
  alamat?: string
}

interface Props {
  data: CustomerData
  errors?: Record<string, string>
}

const props = withDefaults(defineProps<Props>(), {
  errors: () => ({})
})

const form = useForm({
  nama_customer: props.data.nama_customer || '',
  email: props.data.email || '',
  no_telp: props.data.no_telp || '',
  alamat: props.data.alamat || ''
})

const onSubmit = () => {
  form.put(`/master/customer/${props.data.id}`)
}
</script>
