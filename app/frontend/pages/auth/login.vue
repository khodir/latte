<template>
  <Head title="Login" />
  <q-page class="tw-flex tw-justify-center tw-items-center tw-p-5">
    <div class="tw-flex-none md:tw-w-1/2 sm:tw-w-full lg:tw-w-1/3">
      <q-card>
        <q-card-section>
          <div class="text-h6 text-bold">Dealer Management System</div>
          <div class="text-subtitle1">Login Application</div> 
        </q-card-section>
        <q-separator/>
        <q-card-section>
          <q-form @submit.prevent="frm.post('/login')">
            <!-- Email -->
            <q-input label="Email" v-model="frm.email"
            :error="!!frm.errors.email"
            :error-message="frm.errors.email">
              <template v-slot:prepend>
                <q-icon name="fas fa-user-tie"></q-icon>
              </template>
            </q-input>
            <!-- Password -->
            <q-input label="Password" :type="passwordType" v-model="frm.password"
            :error="!!frm.errors.password"
            :error-message="frm.errors.password">
              <template v-slot:prepend>
                <q-icon name="fas fa-lock"></q-icon>
              </template>
              <template v-slot:append>
                <q-icon :name="passwordIcon" @click="showPassword = !showPassword" class="cursor-pointer"></q-icon>
              </template>
            </q-input>
            <!-- Remember Me -->
            <q-checkbox class="q-mt-sm" v-model="frm.remember" label="Remember Me" />
            <!-- Login Button -->
            <div class="row">
              <div class="col">
                <q-btn type="submit" label="Login" color="primary" class="full-width" />
              </div>
            </div>
          </q-form>
        </q-card-section>
        <q-separator/>
        <q-card-section>
          <div class="text-center text-subtitle2">
            Copyright &copy; 2025 BikinApp. All rights reserved.
          </div>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { Head } from '@inertiajs/vue3';
import { inject, onBeforeUnmount, onBeforeMount } from 'vue';
import { useForm } from '@inertiajs/vue3';

const frm = useForm({
  email: '',
  password: '',
  remember: false
});

const showPassword = ref(false);
const passwordType = computed(() => (showPassword.value ? 'text' : 'password'));
const passwordIcon = computed(() => (showPassword.value ? 'fas fa-eye-slash' : 'fas fa-eye'));

// Layout
const layoutData = inject('layoutData') as {
  headerVisible: boolean;
  drawerVisible: boolean;
};

// Hide Layout
onBeforeMount(() => {
  if (layoutData) {
    layoutData.headerVisible = false;
    layoutData.drawerVisible = false;
  }
});

// Show Layout
onBeforeUnmount(() => {
  if (layoutData) {
    layoutData.headerVisible = true;
    layoutData.drawerVisible = true;
  }
});
</script>