<template>
  <q-list dense padding class="rounded-borders menu">
    <template v-for="(item) in data">
      <item :item="item" />
    </template>
  </q-list>
</template>

<style scoped>
.menu :deep(.fas) {
  font-size: unset;
}

.menu :deep(.q-item__section--avatar) {
  min-width: unset;
}

.menu :deep(.q-expansion-item__content > .q-list)  {
  border-left: 1px dashed;
  padding: 5px;
}
</style>

<script setup lang="ts">
import type { MenuItem } from './menu_item';
import Item from './menu_item.vue'

defineOptions({
  name: 'Menu'
})

defineProps<{
  data: MenuItem[]
}>()
</script>