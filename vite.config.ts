import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import { quasar } from '@quasar/vite-plugin'
import path from 'node:path'

export default defineConfig({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, "app/frontend")
    }
  },
  plugins: [
    vue({
      template: {
        transformAssetUrls: {
          base: null,
          includeAbsolute: false
        }
      }
    }),
    quasar(),
    RubyPlugin(),
  ],
})
