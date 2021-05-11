import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ "source" ]

  connect() {
    console.log("Connected")
    this.isPassword = this.sourceTarget.getAttribute("type") === "password"
    if (document.queryCommandSupported("copy")) {
      console.log("Copy supported")
      this.element.querySelector(".hidden").classList.remove("hidden")
    }
  }

  copy () {
    if (this.isPassword) {
      this.sourceTarget.setAttribute("type", "text")
    }
    this.sourceTarget.select()
    document.execCommand("copy")
    if (this.isPassword) {
      this.sourceTarget.setAttribute("type", "password")
    }
  }
}
