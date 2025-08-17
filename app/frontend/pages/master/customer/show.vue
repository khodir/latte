<template>
  <q-page class="q-pa-md">
    <q-card>
      <!-- Headers -->
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-user" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">Customer</span>
          </div>
          <div class="col-auto">
            <Link href="/master/customer/new">
              <q-btn icon="fas fa-plus" color="primary" />
            </Link>
          </div>
        </div>
      </q-card-section>
      <q-separator />
      <!-- Body -->
      <q-card-section>
        <!-- Search -->
        <div class="row q-mb-md">
          <div class="col">
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
        <!-- Table -->
        <q-markup-table flat separator="cell" bordered>
          <thead>
            <tr class="text-body1 tw-font-semibold bg-primary text-white">
              <th></th>
              <th>Nama Customer</th>
              <th>Email</th>
              <th>No. Telp</th>
              <th>Alamat</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="data.length > 0" v-for="row in data" class="text-center">
              <td>
                <!-- Edit -->
                <Link :href="`/master/customer/edit/${row.id}`">
                  <q-btn size="xs" color="positive" icon="fas fa-edit" round />
                </Link>

                <span class="q-mx-sm">
                  |
                </span>

                <!-- Delete -->
                <q-btn size="xs" color="negative" icon="fas fa-trash" round @click="onDelete(row.id)" />
              </td>
              <td>{{ row.nama_customer }}</td>
              <td>{{ row.email || '-' }}</td>
              <td>{{ row.no_telp || '-' }}</td>
              <td>{{ row.alamat || '-' }}</td>
            </tr>
            <tr v-else class="text-center">
              <td colspan="5">
                No customers found.
              </td>
            </tr>
          </tbody>
        </q-markup-table>

        <!-- Pagination -->
        <div class="row q-mt-md">
          <div class="col">
            <span>Showing {{ pagination.from }} to {{ pagination.to }} of {{ pagination.total }}.</span>
            <div class="float-right" v-if="pagination.last_page > 0">
              <q-pagination
                v-model="pagination.current_page"
                :max="pagination.last_page"
                :input="true"
                size="sm"
                @update:model-value="onSearch"
              />
            </div>
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
  router.visit('/master/customer', { 
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
    message: 'Are you sure you want to delete this customer?',
    cancel: true
  }).onOk(() => {
    router.delete(`/master/customer/${id}`, {
      preserveState: true,
      preserveScroll: true,
      replace: true,
      data: searchParam.value,
    });
  });
}
</script>
