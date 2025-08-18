<template>
  <q-page class="q-pa-md">
    <q-card>
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-tags" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">New Category</span>
          </div>
          <div class="col-auto q-gutter-sm">
            <q-btn @click="e => ($refs.categoryFrm as QForm).submit(e)" color="primary" icon="fas fa-save" />
            <q-btn @click="onCancel" color="negative" icon="fas fa-times-circle" />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <q-card class="q-mt-md">
      <q-card-section>
        <q-form ref="categoryFrm" @submit.prevent="frm.post(`/master/category`)">
          <input type="submit" hidden />
          <!-- Row 1 -->
          <div class="row q-col-gutter-sm">
            <!-- ID -->
            <div class="col-12 col-sm-6">
              <q-input filled label="ID" readonly v-model="frm.id" :error="!!frm.errors.id" :error-message="frm.errors.id">
                <template v-slot:prepend>
                  <q-icon name="fas fa-list-ol" />
                </template>
              </q-input>
            </div>
            <!-- Nama Category -->
            <div class="col-12 col-sm-6">
              <q-input filled label="Nama Category" v-model="frm.nama_category" :error="!!frm.errors.nama_category" :error-message="frm.errors.nama_category">
                <template v-slot:prepend>
                  <q-icon name="fas fa-tags" />
                </template>
              </q-input>
            </div>
          </div>
          <!-- Row 2 -->
          <div class="row q-col-gutter-sm">
            <!-- Keterangan -->
            <div class="col-12 col-sm-6">
              <q-input filled rows="3" type="textarea" label="Keterangan" v-model="frm.keterangan" :error="!!frm.errors.keterangan" :error-message="frm.errors.keterangan">
                <template v-slot:prepend>
                  <q-icon name="fas fa-info-circle" />
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

const frm = useForm({
  id: 0,
  nama_category: '',
  keterangan: ''
})

const onCancel = () => router.visit('/master/category');
</script>