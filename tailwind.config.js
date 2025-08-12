/** @type {import('tailwindcss').Config} */
export default {
  prefix: 'tw-',
  content: ["./app/frontend/**/*.{html,js,ts,jsx,tsx,vue,css}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Poppins', 'Lato', 'Quicksand', 'ui-sans-serif', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Helvetica', 'Arial', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'],
      }
    },
  },
  plugins: [],
}

