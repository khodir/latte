<template>
  <q-expansion-item
    v-if="!!item.items"
    v-model="item.expanded"
    :label="item.label"
    :icon="item.icon"
    :content-inset-level="0.5"
    :expand-icon="expandIcon"
    :expanded-icon="expandedIcon"
    dense
    dense-toggle
  >
    <q-list dense>
      <template v-for="subItem in item.items">
        <MenuItem :item="subItem" />
      </template>
    </q-list>
  </q-expansion-item>

  <Link v-else :href="item.link || '#'" :method="item.method as Method || 'get'">
    <q-item dense>
      <q-item-section avatar>
        <q-icon :name="item.icon" />
      </q-item-section>
      <q-item-section>{{ item.label }}</q-item-section>
    </q-item>
  </Link>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { MenuItem as MenuItemType } from './menu_item';
import { Link } from '@inertiajs/vue3';
import { Method } from '@inertiajs/core';

defineOptions({ name: 'MenuItem' })
defineProps<{
  item: MenuItemType
}>()

const expandIcon = ref('fas fa-circle-plus')
const expandedIcon = ref('fas fa-circle-minus')
</script>