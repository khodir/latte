<template>
  <!-- Header -->
  <q-layout view="lHh LpR lFf">
    <q-header v-if="layoutData.headerVisible" elevated class="bg-primary text-white">
      <q-toolbar>
        <q-btn dense flat round :icon="leftDrawerIcon" @click="toggleLeftDrawer" />

        <q-toolbar-title>
          <span>{{ page.props.app_name }}</span>
        </q-toolbar-title>
        <q-space />
        <Link href="/users/sign_out" method="delete">
          <q-btn flat round icon="fas fa-sign-out" />
        </Link>
      </q-toolbar>
    </q-header>

    <q-drawer v-if="layoutData.drawerVisible" style="width: 400px;" class="column" show-if-above v-model="leftDrawerOpen" side="left" bordered>
      <div class="text-center q-pa-sm">
        <!-- Avatar -->
        <div>
          <q-avatar size="80px" class="bg-grey-3">
            <q-icon name="fas fa-user-tie" color="primary" size="50px" />
          </q-avatar>
        </div>
        <!-- Username -->
        <div class="text-body1 text-bold q-mt-sm">{{ auth?.user?.email }}</div>
        <!-- User Role -->
        <!-- <div class="text-subtitle2 text-grey-7">{{ auth?.user?.name }}</div> -->
        <!-- Changeable Current Branch -->
        <div class="text-subtitle2 text-grey-7 q-mt-xs">
          {{ auth?.perusahaan?.nama_perusahaan }}
          <!-- <q-btn outline size="sm" class="q-ml-sm" color="primary" icon="fas fa-pencil-alt" /> -->
        </div>
      </div>
      
      <!-- Drawer -->
      <q-separator class="q-my-sm" />

      <!-- Menu -->
      <q-scroll-area style="flex-grow: 1;">
        <Menu :data="menu.data" class="menu" />
      </q-scroll-area>
    </q-drawer>

    <q-page-container>
      <slot />
    </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
import { computed, ref, provide, reactive } from 'vue'
import { Link, usePage, router } from '@inertiajs/vue3'
import Menu from '@/components/menu/menu.vue'
import menuitems from "@/menu.json"
import { useQuasar } from 'quasar'

const q = useQuasar();
const page = usePage()
const { auth } = defineProps(['auth'])

const menu = ref({ data: menuitems })
const leftDrawerOpen = ref(false)
const leftDrawerIcon = computed(() => leftDrawerOpen.value ? 'fas fa-circle-chevron-left' : 'fas fa-circle-chevron-right')
const toggleLeftDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

const layoutData = reactive({
  headerVisible: true,
  drawerVisible: true,
})

provide('layoutData', layoutData)

router.on('finish', () => {
  if (!!page.props.flash?.error) {
    q.notify({
      type: 'negative',
      message: page.props.flash.error,
      position: 'top-right',
      timeout: 3000
    });
  }

  if (!!page.props.flash?.success) {
    q.notify({
      type: 'positive',
      message: page.props.flash.success,
      position: 'top-right',
      timeout: 3000
    });
  }

  if (!!page.props.flash?.notice) {
    q.notify({
      type: 'info',
      message: page.props.flash.notice,
      position: 'top-right',
      timeout: 3000
    });
  }

  if (!!page.props.flash?.alert) {
    q.notify({
      type: 'warning',
      message: page.props.flash.alert,
      position: 'top-right',
      timeout: 3000
    });
  }
})
</script>