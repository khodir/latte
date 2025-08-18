<template>
  <q-page class="q-pa-md">
    <q-card>
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-box" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">Edit Item</span>
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
          <!-- Upload Image -->
          <div class="tw-flex tw-justify-center tw-items-center tw-mb-4">
            <div class="tw-flex-none md:tw-w-1/2 sm:tw-w-full lg:tw-w-1/3">
              <q-uploader accept="image/jpeg,image/jpg,image/png,image/bpm,image/gif,image/webp" label="Image" 
                @added="files => frm.image = files[0]"
                @removed="frm.image = null" :multiple="false"
                v-if="data.image_url === null"
              />
              <div v-else class="tw-flex tw-flex-col tw-items-center">
                <q-img :src="data.image_url" class="tw-mb-2" />
                <q-btn label="Delete Image" outline @click="() => { data.image_url = null; frm.delete_image = true; }" color="negative" icon="fas fa-times-circle" />
              </div>
            </div>
          </div>
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
            <!-- Kode Item -->
            <div class="col-12 col-sm-6">
              <q-input filled label="Kode Item" v-model="frm.kode_item" :error="!!frm.errors.kode_item" :error-message="frm.errors.kode_item">
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
              <q-input filled label="Nama Item" v-model="frm.nama_item" :error="!!frm.errors.nama_item" :error-message="frm.errors.nama_item">
                <template v-slot:prepend>
                  <q-icon name="fas fa-box" />
                </template>
              </q-input>
            </div>
            <!-- Category -->
            <div class="col-12 col-sm-6">
              <q-select
                filled
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
import { ref } from 'vue';

const { categories, data } = defineProps(['categories', 'data'])
const frm = useForm({
  id: data.id,
  kode_item: data.kode_item,
  nama_item: data.nama_item,
  keterangan: data.keterangan,
  category: data.category,
  image: null,
  delete_image: false as boolean
})

const onSubmit = () => {
  frm.transform(d => {
    return {
      ...d,
      item_category_attributes: [
        ...d.category.map((v: any) => { 
          return {
            category_id: v.id,
            id: data.item_category.filter((ic: any) => ic.category_id === v.id).length > 0 ?
              data.item_category.filter((ic: any) => ic.category_id === v.id)[0].id :
              null
          }
        }),
        ...data.item_category.filter((ic: any) => d.category.filter((v: any) => v.id === ic.category_id).length <= 0)
          .map((ic: any) => ({ id: ic.id, category_id: ic.category_id, _destroy: 1 }))
      ]
    }
  })
  .put(`/master/item/${data.id}`, { forceFormData: true })
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