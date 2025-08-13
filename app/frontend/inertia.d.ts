// types/inertia.d.ts
import { PageProps as InertiaPageProps } from '@inertiajs/core'

declare module '@inertiajs/core' {
  interface PageProps extends InertiaPageProps {
    auth?: {
      user: {
        id: number
        name: string
        email: string
        // Add more fields as needed
      },
      perusahaan: {
        nama_perusahaan: string
      }
    }
    flash?: {
      notice?: string
      alert?: string
      success?: string
      error?: string
    }
    // Add other shared props here
  }
}