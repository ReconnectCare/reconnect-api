// MENU
export default function () {
  function setup_menu (script) {
    var els = document.querySelectorAll('div[data-menu]')
    if (els.length > 0) {
      var el = els[0]
      el.addEventListener('click', function (e) {
        var id = e.currentTarget.getAttribute('data-menu')
        var el = document.querySelectorAll('#' + id)[0]
        el.classList.toggle('hidden')
      })
    }
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () { setup_menu() })
  } else {
    setup_menu()
  }
}
