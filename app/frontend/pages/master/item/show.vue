<template>
  <q-page class="q-pa-md">
    <!-- Page Header -->
    <q-card>
      <!-- Header -->
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-box" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">Item</span>
          </div>
          <div class="col-auto">
            <!-- Add New -->
            <Link href="/master/item/new">
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
              filled
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
          <div class="col-12 col-sm-6">
            <q-select
              filled
              label="Kategori"
              v-model="cat"
              :options="listCategory"
              option-label="nama_category"
              option-value="id"
              emit-value map-options
              multiple use-input use-chips @filter="filterCategory"
              clearable
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
        <div class="row q-mt-sm">
          <div class="col-12">
            <q-toggle v-model="showAsTable" label="Table View" />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Page Data -->
    <q-markup-table v-if="showAsTable" class="q-mt-md" separator="cell">
      <thead>
        <tr class="text-body1 tw-font-semibold bg-primary text-white">
          <th></th>
          <th>Kode Item</th>
          <th>Nama Item</th>
          <th>Kategori</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="data.length > 0" v-for="row in data" class="text-center">
          <td>
            <!-- Edit -->
            <Link :href="`/master/item/edit/${row.id}`">
              <q-btn size="xs" color="positive" icon="fas fa-edit" round />
            </Link>

            <span class="q-mx-sm">
              |
            </span>

            <!-- Delete -->
            <q-btn size="xs" color="negative" icon="fas fa-trash" round @click="onDelete(row.id)" />
          </td>
          <td>{{ row.kode_item }}</td>
          <td>{{ row.nama_item }}</td>
          <td>
            {{ row.category.map((c: any) => c.nama_category).join(', ') }}
          </td>
        </tr>
        <tr v-else class="text-center">
          <td colspan="4">
            No items found.
          </td>
        </tr>
      </tbody>
    </q-markup-table>

    <!-- Card View -->
    <div v-else>
      <div class="row q-col-gutter-md q-mt-md" v-for="rows in chunk(data, cardRowSize)">
        <div class="col-12 col-sm-6 col-md-3" v-for="row in (rows as any)" :key="row.id">
          <q-card v-ripple style="width: 100%;">
            <!-- Media -->
            <Link :href="`/master/item/edit/${row.id}`">
              <q-img :src="row.image_url" width="100%" :ratio="16/9"></q-img>
            </Link>
            <!-- Data -->
            <q-card-section class="q-pt-sm">
              <!-- Nama Item and Kode Item -->
              <div class="text-subtitle1 tw-overflow-x-hidden tw-whitespace-nowrap tw-truncate">
                <span class="tw-font-semibold">{{ row.nama_item }}</span>
              </div>
              <div class="text-caption text-italic tw-overflow-x-hidden tw-whitespace-nowrap tw-truncate">
                {{ row.kode_item }}
              </div>
              <!-- Categories -->
              <div class="tw-overflow-x-hidden tw-whitespace-nowrap tw-truncate">
                <q-chip v-for="cat in row.category" size="sm" color="primary" text-color="white">
                  {{ cat.nama_category }}
                </q-chip>
              </div>

              <!-- Description -->
              <q-separator class="q-my-sm" />
              <div class="tw-overflow-x-hidden tw-whitespace-nowrap tw-truncate">
                {{ row.keterangan || '-' }}
              </div>

              <!-- Action -->
              <div class="row q-pt-sm">
                <div class="col">
                  <div class="float-right">
                    <Link :href="`/master/item/edit/${row.id}`" class="q-mr-sm">
                      <q-btn icon="fas fa-edit" color="primary" outline/>
                    </Link>
                    <q-btn @click="onDelete(row.id)" icon="fas fa-trash" color="negative" outline/>
                  </div>
                </div>
              </div>
            </q-card-section>
          </q-card>
        </div>
      </div>
    </div>

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
import { computed, ref, watch } from 'vue';
import { useQuasar } from 'quasar';
import { chunk } from 'lodash';

const q = useQuasar();
const cardRowSize = computed(() => {
  return q.screen.lt.sm ? 1 : q.screen.lt.md ? 2 : 4;
});

const { pagination, categories, data } = defineProps(['pagination', 'categories', 'data']);
const search = ref('');
const cat = ref([]);
const showAsTable = ref(false);

const allCategory = ref(categories || []);
const listCategory = ref(categories || []);
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

const searchParam = computed(() => {
  return { q: search.value, c: cat.value, page: pagination.current_page, per_page: pagination.per_page }
});

const onSearch = () => {
  router.visit('/master/item', { 
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
    message: 'Are you sure you want to delete this item?',
    cancel: true
  }).onOk(() => {
    router.delete(`/master/item/${id}`, {
      preserveState: true,
      preserveScroll: true,
      replace: true,
      data: searchParam.value
    });
  });
}

watch(
  () => cat.value,
  () => onSearch()
)
</script>