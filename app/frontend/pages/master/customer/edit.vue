<template>
  <q-page class="q-pa-md">
    <q-card>
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-user" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">Edit Customer</span>
          </div>
          <div class="col-auto q-gutter-sm">
            <q-btn @click="e => ($refs.customerFrm as QForm).submit(e)" color="primary" icon="fas fa-save" />
            <q-btn @click="onCancel" color="negative" icon="fas fa-times-circle" />
          </div>
        </div>
      </q-card-section>
      <q-separator/>
      <q-card-section>
        <q-form ref="customerFrm" @submit.prevent="frm.put(`/master/customer/${data.id}`)">
          <input type="submit" hidden />
          <!-- Row 1 -->
          <div class="row q-col-gutter-sm">
            <!-- ID -->
            <div class="col-12 col-sm-6">
              <q-input label="ID" readonly v-model="frm.id" :error="!!frm.errors.id" :error-message="frm.errors.id">
                <template v-slot:prepend>
                  <q-icon name="fas fa-list-ol" />
                </template>
              </q-input>
            </div>
            <!-- Nama Customer -->
            <div class="col-12 col-sm-6">
              <q-input label="Nama Customer" v-model="frm.nama_customer" :error="!!frm.errors.nama_customer" :error-message="frm.errors.nama_customer">
                <template v-slot:prepend>
                  <q-icon name="fas fa-user" />
                </template>
              </q-input>
            </div>
          </div>
          <!-- Row 2 -->
          <div class="row q-col-gutter-sm">
            <!-- Email -->
            <div class="col-12 col-sm-6">
              <q-input label="Email" v-model="frm.email" :error="!!frm.errors.email" :error-message="frm.errors.email">
                <template v-slot:prepend>
                  <q-icon name="fas fa-envelope" />
                </template>
              </q-input>
            </div>
            <!-- No Telp -->
            <div class="col-12 col-sm-6">
              <q-input label="No. Telp" v-model="frm.no_telp" :error="!!frm.errors.no_telp" :error-message="frm.errors.no_telp">
                <template v-slot:prepend>
                  <q-icon name="fas fa-phone" />
                </template>
              </q-input>
            </div>
          </div>
          <!-- Row 3 -->
          <div class="row q-col-gutter-sm">
            <!-- Alamat -->
            <div class="col-12">
              <q-input type="textarea" label="Alamat" v-model="frm.alamat" :error="!!frm.errors.alamat" :error-message="frm.errors.alamat">
                <template v-slot:prepend>
                  <q-icon name="fas fa-map-marker-alt" />
                </template>
              </q-input>
            </div>
          </div>
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script lang="ts" setup>
import { useForm, router } from '@inertiajs/vue3';
import { QForm } from 'quasar';

const { data } = defineProps(['data']);
const frm = useForm({
  id: data.id,
  nama_customer: data.nama_customer,
  email: data.email,
  no_telp: data.no_telp,
  alamat: data.alamat
})

const onCancel = () => router.visit('/master/customer');
</script>
