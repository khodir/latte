<template>
  <q-dialog :model-value="dialog" persistent>
    <q-card class="tw-w-11/12 md:tw-w-2/3">
      <q-card-section class="bg-primary text-white">
        <div class="row items-center">
          <div class="col">
            <span class="q-mr-md">
              <q-icon name="fas fa-ellipsis-v"></q-icon>
            </span>
            {{ mode === 'new' ? 'Add' : 'Edit' }} Variation
          </div>
          <div class="col-auto">
            <!-- Cancel -->
            <q-btn @click="onCancel" size="sm" round icon="fas fa-times" color="negative" />
          </div>
        </div>
      </q-card-section>
      <q-separator />
      <q-card-section>
        <q-form ref="frm" @submit.prevent="onSave">
          <input type="submit" hidden>
          <!-- Variation Name -->
          <div class="row">
            <div class="col">
              <q-input :rules="rules.variation_name" class="required" v-model="model.variation_name" label="Name (eg: topping)" />
            </div>
          </div>

          <!-- Separator -->
          <div class="row q-mt-lg">
            <div class="col">
              <div class="text-caption1 text-grey tw-font-semibold">
                <u>Options :</u>
              </div>
            </div>
          </div>

          <!-- Values -->
          <div class="row items-center q-col-gutter-sm" v-for="(item, idx) in model.item_variation_value_attributes">
            <!-- Value -->
            <div class="col-5">
              <q-input :rules="rules.variation_value" class="required" v-model="item.variation_value" label="Option (eg: jelly)" />
            </div>
            <!-- Additional Price -->
            <div class="col-5">
              <NumberInput :rules="rules.additional_price" class="required" v-model="item.additional_price" label="+Price" />
            </div>
            <div class="col-2">
              <!-- Remove -->
              <q-btn @click="removeOption(idx)" round icon="fas fa-trash" size="sm" color="negative">
                <q-tooltip>Delete Option</q-tooltip>
              </q-btn>
            </div>
          </div>

          <!-- Add Values -->
          <div class="row q-mt-sm">
            <div class="col">
              <q-btn @click="addOption" round icon="fas fa-plus" size="sm" color="positive">
                <q-tooltip>Add Option</q-tooltip>
              </q-btn>
            </div>
          </div>
        </q-form>
      </q-card-section>
      <q-card-actions class="justify-end">
        <!-- Save -->
        <q-btn @click="e => $refs.frm.submit(e)" color="primary" icon="fas fa-save" label="Simpan" />
        <!-- Cancel -->
        <q-btn @click="onCancel" color="negative" icon="fas fa-times" label="Batal" />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { reactive, ref } from 'vue';
import NumberInput from '@/components/number_input/number_input.vue';

const { dialog, data } = defineProps(['dialog', 'data']);
const emit = defineEmits(['save', 'cancel']);

const cidx = ref(0);
const mode = ref('new');
const model = reactive({
  id: null,
  variation_name: '',
  item_variation_value_attributes: [
    { id: null, variation_value: "", additional_price: 0 }
  ]
});

const rules = reactive({
  variation_name: [
    v => !!v || "Name is Required"
  ],
  variation_value: [
    v => !!v || "Option name is Required"
  ],
  additional_price: [
    v => {
      if (v <= 0) {
        return "Additional price must be greater than or equal to 0"
      }
      
      return true;
    }
  ]
})

const onNew = () => {
  mode.value = 'new';
  Object.assign(model, {
    id: null,
    variation_name: '',
    item_variation_value_attributes: [
      { id: null, variation_value: '', additional_price: 0 }
    ]
  })
}

const onEdit = (idx) => {
  mode.value = 'edit';
  cidx.value = idx;
  Object.assign(model, data[idx])
}

const onCancel = () => emit('cancel')
const onSave = () => emit('save', model);

const addOption = () => {
  model.item_variation_value_attributes.push({
    id: null, 
    variation_value: '', 
    additional_price: 0
  })
}

const removeOption = (idx) => {
  model.item_variation_value_attributes.splice(idx, 1)
}

defineExpose({
  onNew,
  onEdit,
  onCancel,
  onSave,
  mode,
  cidx
})
</script>