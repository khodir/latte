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
            <q-btn @click="e => $refs.itemFrm.submit(e)" color="primary" icon="fas fa-save" />
            <q-btn @click="onCancel" color="negative" icon="fas fa-times-circle" />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <div class="row q-col-gutter-md q-pt-md">
      <!-- Item -->
      <div class="col-12 col-sm-7">
        <q-card>
          <q-card-section>
            <q-form ref="itemFrm" @submit.prevent="onSubmit">
              <input type="submit" hidden />
              <!-- Upload Image -->
              <div class="tw-flex tw-justify-center tw-items-center tw-mb-4">
                <div class="tw-flex-none md:tw-w-1/2 sm:tw-w-full lg:tw-w-1/3">
                  <q-uploader accept="image/jpeg,image/jpg,image/png" label="Image" 
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
                <!-- Kode Item -->
                <div class="col-12 col-sm-6">
                  <q-input label="Kode Item" v-model="frm.kode_item" :error="!!frm.errors.kode_item" :error-message="frm.errors.kode_item">
                    <template v-slot:prepend>
                      <q-icon name="fas fa-list-ul" />
                    </template>
                  </q-input>
                </div>
                <!-- Nama Item -->
                <div class="col-12 col-sm-6">
                  <q-input label="Nama Item" v-model="frm.nama_item" :error="!!frm.errors.nama_item" :error-message="frm.errors.nama_item">
                    <template v-slot:prepend>
                      <q-icon name="fas fa-box" />
                    </template>
                  </q-input>
                </div>
              </div>
              <!-- Row 2 -->
              <div class="row q-col-gutter-sm">
                <!-- Harga -->
                <div class="col-12 col-sm-6">
                  <NumberInput label="Harga" v-model="frm.price" :error="!!frm.errors.price" :error-message="frm.errors.price">
                    <template v-slot:prepend>
                      <q-icon name="fas fa-tag" />
                    </template>
                  </NumberInput>
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
      </div>

      <!-- Item Variation -->
      <div class="col-12 col-sm-5">
        <q-list class="bg-white shadow-2">
          <q-expansion-item v-model="itemVariationExpanded" expand-separator label="Variation" icon="fas fa-ellipsis-v">
            <q-separator/>
            <q-card>
              <q-card-section>
                <!-- Variation -->
                <div v-for="(variation, index) in frm.item_variation_attributes" :key="index">
                  <div class="row items-center">
                    <div class="col">
                      <q-btn flat round icon="fas fa-edit" color="positive" size="sm" />
                      {{ variation.variation_name }}
                    </div>
                    <div class="col-auto">
                      <q-btn flat round icon="fas fa-trash" color="negative" size="sm" />
                    </div>
                  </div>
                  <!-- Variation Value -->
                  <div class="row q-py-sm">
                    <div class="col">
                      <ul>
                        <li v-for="(var_value, index) in variation.item_variation_value_attributes" :key="index">
                          {{ var_value.variation_value }}
                        </li>
                      </ul>
                    </div>
                  </div>
                  <!-- Separator -->
                  <q-separator 
                    v-if="frm.item_variation_attributes.length > 1 && index < frm.item_variation_attributes.length - 1" 
                    class="q-my-sm" />
                </div>
              </q-card-section>
              <q-card-actions>
                <q-btn color="primary" icon="fas fa-plus" @click="addVariation">
                  <q-tooltip>Add Variation</q-tooltip>
                </q-btn>
              </q-card-actions>
            </q-card>
          </q-expansion-item>
        </q-list>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { useForm, router } from '@inertiajs/vue3';
import { QForm } from 'quasar';
import { ref } from 'vue';
import NumberInput from "@/components/number_input/number_input.vue";

const itemVariationExpanded = ref(true)
const { categories, data } = defineProps(['categories', 'data'])
const frm = useForm({
  id: data.id,
  kode_item: data.kode_item,
  nama_item: data.nama_item,
  keterangan: data.keterangan,
  category: data.category,
  price: data.price,
  image: null,
  delete_image: false,
  item_variation_attributes: []
})

// submit
const onSubmit = () => {
  frm.transform(d => {
    return {
      ...d,
      item_category_attributes: [
        ...d.category.map((v) => { 
          return {
            category_id: v.id,
            id: data.item_category.filter((ic) => ic.category_id === v.id).length > 0 ?
              data.item_category.filter((ic) => ic.category_id === v.id)[0].id :
              null
          }
        }),
        ...data.item_category.filter((ic) => d.category.filter((v) => v.id === ic.category_id).length <= 0)
          .map((ic) => ({ id: ic.id, category_id: ic.category_id, _destroy: 1 }))
      ]
    }
  })
  .put(`/master/item/${data.id}`, { forceFormData: true })
}

// filter category
const allCategory = ref(categories);
const listCategory = ref(categories);
const filterCategory = (query, update) => {
  if (query.trim() === '') {
    update(() => {
      listCategory.value = allCategory.value
    })
  } else {
    update(() => {
      const q = query.toLowerCase()
      listCategory.value = allCategory.value.filter((v) => v.nama_category.toLowerCase().indexOf(q) > -1)
    })
  }
}

// cancel
const onCancel = () => router.visit('/master/item');

// add variation
const addVariation = () => {
  frm.item_variation_attributes.push({
    id: null,
    variation_name: `Options ${frm.item_variation_attributes.length + 1}`,
    item_variation_value_attributes: [
      { id: null, variation_value: "Value 1", additional_price: 0 }
    ]
  })
}

// remove variation
const removeVariation = (index) => {
  frm.item_variation_attributes.splice(index, 1)
}

// remove variation value
const removeVariationValue = (variationIndex, valueIndex) => {
  frm.item_variation_attributes[variationIndex].item_variation_value_attributes.splice(valueIndex, 1)
}
</script>