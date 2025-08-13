<template>
  <q-page class="q-pa-md">
    <q-card>
      <!-- Headers -->
      <q-card-section>
        <div class="row items-center">
          <div class="col">
            <q-icon name="fas fa-box" size="sm" class="text-primary q-pr-md" />
            <span class="text-subtitle1">Item</span>
          </div>
          <div class="col-auto">
            <Link href="/master/item/new">
              <q-btn icon="fas fa-plus" color="primary" />
            </Link>
          </div>
        </div>
      </q-card-section>
      <q-separator />
      <!-- Body -->
      <q-card-section>
        <!-- Search -->
        <div class="row q-col-gutter-md">
          <div class="col-12 col-sm-8">
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
          <div class="col-12 col-sm-4">
            <q-select
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

        <div class="row q-mb-md">
          <div class="col-12">
            <q-toggle v-model="showAsTable" label="Table View" class="q-ml-md" />
          </div>
        </div>
        
        <!-- Table -->
        <q-markup-table v-if="showAsTable" flat separator="cell" bordered>
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
                No categories found.
              </td>
            </tr>
          </tbody>
        </q-markup-table>

        <div v-else class="row q-col-gutter-md">
          <div class="col-12 col-sm-6 col-md-4" v-for="row in data" :key="row.id">
            <q-card flat bordered v-ripple>
              <!-- Media -->
              <Link :href="`/master/item/edit/${row.id}`">
                <q-img :src="row.image_url" width="100%" :ratio="16/9"></q-img>
              </Link>
              <!-- Data -->
              <q-card-section class="q-pt-sm">
                <!-- Nama Item and Kode Item -->
                <div class="text-subtitle1">
                  <span class="tw-font-semibold">{{ row.nama_item }}</span>
                  <span class="text-caption q-ml-sm text-italic">{{ row.kode_item }}</span>
                </div>
                <!-- Categories -->
                <div>
                  <q-chip v-for="cat in row.category" size="sm" color="primary" text-color="white">
                    {{ cat.nama_category }}
                  </q-chip>
                </div>

                <!-- Description -->
                <q-separator class="q-my-sm" />
                {{ row.keterangan }}

                <!-- Action -->
                <div class="row">
                  <div class="col">
                    <div class="float-right">
                      <q-btn @click="onDelete(row.id)" icon="fas fa-trash" color="negative" outline/>
                    </div>
                  </div>
                </div>
              </q-card-section>
            </q-card>
          </div>
        </div>

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
import { ref, watch } from 'vue';
import { useQuasar } from 'quasar';

const q = useQuasar();

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

const onSearch = () => {
  router.visit('/master/item', { 
    replace: true,
    preserveScroll: true,
    preserveState: true,
    preserveUrl: true,
    only: ['pagination', 'categories', 'data'], 
    data: { q: search.value, c: cat.value?.join(','), page: pagination.current_page, per_page: pagination.per_page } 
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
      only: ['pagination', 'data', 'flash']
    });
  });
}

watch(
  () => cat.value,
  () => onSearch()
)
</script>