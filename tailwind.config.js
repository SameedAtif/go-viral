/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{html,js,erb}",
    "./node_modules/flowbite/**/*.js",
    './app/views/**/*',
  ],
  theme: {
    extend: {},
  },
  corePlugins: {
    aspectRatio: false,
  },
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('flowbite/plugin'),
  ],
}

