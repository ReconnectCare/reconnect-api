import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ "newRow" ]

  initialize() {
    this.newRow = this.newRowTarget.cloneNode(true);
    this.newRowTarget.parentNode.removeChild(this.newRowTarget);
  }

  add (e) {
    e.preventDefault()
    e.stopImmediatePropagation()
    this.element.querySelector("div").appendChild(this.newRow.cloneNode(true))
  }

  remove (e) {
    e.preventDefault()
    e.stopImmediatePropagation()
    var el = e.currentTarget.closest("div")
    el.parentNode.removeChild(el)
  }
}
