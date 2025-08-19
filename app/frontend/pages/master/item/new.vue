<template>
  <q-page class="q-pa-md">
    <q-card>
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-box" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">New Item</span>
          </div>
          <div class="col-auto q-gutter-sm">
            <q-btn @click="e => ($refs.itemFrm as QForm).submit(e)" color="primary" icon="fas fa-save" />
            <q-btn @click="onCancel" color="negative" icon="fas fa-times-circle" />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <q-card class="q-mt-md">
      <q-card-section>
        <q-form ref="itemFrm" @submit.prevent="onSubmit">
          <input type="submit" hidden />
          <!-- Image Upload -->
          <div class="tw-flex tw-justify-center tw-items-center tw-mb-4">
            <div class="tw-flex-none md:tw-w-1/2 sm:tw-w-full lg:tw-w-1/3">
              <q-uploader accept="image/jpeg,image/jpg,image/png" label="Image" 
                @added="files => frm.image = files[0]" :multiple="false"
                @removed="frm.image = null"
              />
            </div>
          </div>
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
            <!-- Kode Item -->
            <div class="col-12 col-sm-6">
              <q-input label="Kode Item" v-model="frm.kode_item" :error="!!frm.errors.kode_item" :error-message="frm.errors.kode_item">
                <template v-slot:prepend>
                  <q-icon name="fas fa-list-ul" />
                </template>
              </q-input>
            </div>
          </div>
          <!-- Row 2 -->
          <div class="row q-col-gutter-sm">
            <!-- Nama Item -->
            <div class="col-12 col-sm-6">
              <q-input label="Nama Item" v-model="frm.nama_item" :error="!!frm.errors.nama_item" :error-message="frm.errors.nama_item">
                <template v-slot:prepend>
                  <q-icon name="fas fa-box" />
                </template>
              </q-input>
            </div>
            <!-- Category -->
            <div class="col-12 col-sm-6">
              <q-select
                label="Kategori"
                v-model="frm.category"
                :options="listCategory"
                :error="!!frm.errors.category"
                :error-message="frm.errors.category"
                option-label="nama_category"
                multiple use-input use-chips @filter="filterCategory"
              >
                <template v-slot:prepend>
                  <q-icon name="fas fa-tags"></q-icon>
                </template>
                <template v-slot:selected-item="scope">
                  <q-chip removable @remove="scope.removeAtIndex(scope.index)" 
                  :tabindex="scope.tabindex" dense color="secondary" text-color="white" size="sm"
                  class="q-ma-none">
                    {{ scope.opt.nama_category }}
                  </q-chip>
                </template>
              </q-select>
            </div>
          </div>
          <!-- Row 3 -->
          <div class="row q-col-gutter-sm">
            <!-- Keterangan -->
            <div class="col-12 col-sm-6">
              <q-input rows="3" type="textarea" label="Keterangan" v-model="frm.keterangan" :error="!!frm.errors.keterangan" :error-message="frm.errors.keterangan">
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
import { ref } from 'vue';

const { categories } = defineProps(['categories'])
const frm = useForm({
  id: 0,
  kode_item: '',
  nama_item: '',
  keterangan: '',
  category: [],
  image: null
})

const onSubmit = () => {
  frm.transform(d => {
    return {
      ...d,
      item_category_attributes: d.category.map((v: any) => ({ category_id: v.id }))
    }
  })
  .post("/master/item", { forceFormData: true })
}

// filter category
const allCategory = ref(categories);
const listCategory = ref(categories);
const filterCategory = (query: string, update: (fn: () => void) => void) => {
  if (query.trim() === '') {
    update(() => {
      listCategory.value = allCategory.value
    })
  } else {
    update(() => {
      const q = query.toLowerCase()
      listCategory.value = allCategory.value.filter((v: any) => v.nama_category.toLowerCase().indexOf(q) > -1)
    })
  }
}

const onCancel = () => router.visit('/master/item');
</script>