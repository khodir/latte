<template>
  <q-input 
    label="Harga"
    :type="inputType"
    :error="!!error" 
    :error-message="errorMessage"
    v-model="txtValue"
    @update:modelValue="onUpdate"
    @focus="onFocus"
    @blur="onBlur"
    min="0"
    precision="2"
    step="100"
  >
    <template v-slot:prepend>
      <slot name="prepend"></slot>
    </template>
    <template v-slot:append>
      <slot name="append"></slot>
    </template>
  </q-input>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { formatNumber, unformat } from 'accounting';

defineOptions({name: 'NumberInput'})
const { modelValue, error, errorMessage } = defineProps(['modelValue', 'error', 'errorMessage'])
const emit = defineEmits(['update:modelValue'])

const config = {
  precision: 2,
  thousand: ".",
  decimal: ","
}

const inputType = ref('text')
const txtValue = ref('0');

const onUpdate = () => {
  emit('update:modelValue', unformat(txtValue.value));
}

const onFocus = () => {
  if (modelValue <= 0 || modelValue === null) txtValue.value = '';
  else txtValue.value = unformat(modelValue);
  
  inputType.value = 'number';
}

const onBlur = () => {
  txtValue.value = formatNumber(modelValue, config);
  inputType.value = 'text';
}

onMounted(() => {
  txtValue.value = formatNumber(modelValue, config)
})
</script>
