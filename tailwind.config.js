module.exports = {
  purge: [
    './app/**/*.html',
    './app/**/*.html.slim',
    './app/**/*.html.erb',
    './app/**/*.js',
    './app/helpers/*.rb'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {}
  },
  variants: {},
  plugins: []
}
