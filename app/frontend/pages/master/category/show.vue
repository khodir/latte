<template>
  <q-page class="q-pa-md">
    <!-- Page Header -->
    <q-card>
      <!-- Header -->
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-tags" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">Category</span>
          </div>
          <div class="col-auto">
            <!-- Add New -->
            <Link href="/master/category/new">
              <q-btn icon="fas fa-plus" color="primary" />
            </Link>
          </div>
        </div>
      </q-card-section>
      <q-separator/>
      <!-- Search -->
      <q-card-section>
        <div class="row q-col-gutter-sm">
          <div class="col-12 col-sm-6">
            <q-input
              v-model="search"
              debounce="300"
              placeholder="Search Here..."
              class="full-width"
              @update:model-value="onSearch"
            >
              <template v-slot:prepend>
                <q-icon name="fab fa-searchengin"/>
              </template>
            </q-input>
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Page Data -->
    <q-markup-table class="q-mt-md" separator="cell">
      <thead>
        <tr class="text-body1 tw-font-semibold bg-primary text-white">
          <th></th>
          <th>Nama Category</th>
          <th>Keterangan</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="data.length > 0" v-for="row in data" class="text-center">
          <td>
            <!-- Edit -->
            <Link :href="`/master/category/edit/${row.id}`">
              <q-btn size="xs" color="positive" icon="fas fa-edit" round />
            </Link>

            <span class="q-mx-sm">
              |
            </span>

            <!-- Delete -->
            <q-btn size="xs" color="negative" icon="fas fa-trash" round @click="onDelete(row.id)" />
          </td>
          <td>{{ row.nama_category }}</td>
          <td>{{ row.keterangan }}</td>
        </tr>
        <tr v-else class="text-center">
          <td colspan="3">
            No categories found.
          </td>
        </tr>
      </tbody>
    </q-markup-table>

    <!-- Pagination -->
    <q-card class="q-mt-md">
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <span class="text-caption1">
              Showing {{ pagination.from }} to {{ pagination.to }} of {{ pagination.total }}.
            </span>
          </div>
          <div class="col-auto">
            <q-pagination
              v-model="pagination.current_page"
              :max="pagination.last_page"
              :input="true"
              size="sm"
              @update:model-value="onSearch"
            />
          </div>
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { useQuasar } from 'quasar';

const q = useQuasar();
const search = ref('');
const { pagination, data } = defineProps(['pagination', 'data']);
const searchParam = computed(() => {
  return { q: search.value, page: pagination.current_page, per_page: pagination.per_page }
})

const onSearch = () => {
  router.visit('/master/category', { 
    replace: true,
    preserveScroll: true,
    preserveState: true,
    preserveUrl: true,
    data: searchParam.value
  });
};

const onDelete = (id: Number) => {
  q.dialog({
    title: 'Confirm Deletion',
    message: 'Are you sure you want to delete this category?',
    cancel: true
  }).onOk(() => {
    router.delete(`/master/category/${id}`, {
      preserveState: true,
      preserveScroll: true,
      replace: true,
      data: searchParam.value,
    });
  });
}
</script>