import { createInertiaApp } from '@inertiajs/vue3'
import { createApp, DefineComponent, h } from 'vue'
import { Quasar, Dialog, Notify, Loading, LoadingBar } from 'quasar';
import quasarIconset from "quasar/icon-set/fontawesome-v6";
import Layout from '@/layouts/app.vue'

createInertiaApp({
  // Set default page title
  // see https://inertia-rails.dev/guide/title-and-meta
  //
  title: title => title ? `Latte ${title}` : 'Latte',

  // Disable progress bar
  //
  // see https://inertia-rails.dev/guide/progress-indicators
  // progress: false,

  resolve: (name) => {
    const pages = import.meta.glob<DefineComponent>('../pages/**/*.vue', {
      eager: true,
    })
    // return pages[`../pages/${name}.vue`]

    // To use a default layout, import the Layout component
    // and use the following lines.
    // see https://inertia-rails.dev/guide/pages#default-layouts
    //
    const page = pages[`../pages/${name}.vue`]
    page.default.layout = page.default.layout || Layout
    return page
  },

  setup({ el, App, props, plugin }) {
    createApp({ render: () => h(App, props) })
      .use(plugin)
      .use(Quasar, {
        plugins: { Dialog, Notify, Loading, LoadingBar },
        iconSet: quasarIconset,
        config: {
          brand: {
            primary: '#2b5c8c',
            secondary: '#1e877d',
            accent: '#9C27B0',

            dark: '#1d1d1d',
            'dark-page': '#121212',

            positive: '#1a7830',
            negative: '#C10015',
            info: '#129ab5',
            warning: '#F2C037'
          }
        }
      })
      .mount(el)
  },
})
