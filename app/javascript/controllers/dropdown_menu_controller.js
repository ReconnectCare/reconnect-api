import { Controller } from 'stimulus'

export default class extends Controller {
  initialize () {
    this.show = this.show.bind(this)
    this.hide = this.hide.bind(this)
  }

  connect () {
    this.element.addEventListener('mouseenter', this.show)
    this.element.addEventListener('mouseleave', this.hide)
  }

  disconnect () {
    this.element.removeEventListener('mouseenter', this.show)
    this.element.removeEventListener('mouseleave', this.hide)
  }

  show () {
    window.clearTimeout(this.hideTimeout)
    this.element.querySelector('ul').classList.remove('hidden')
    window.setTimeout(() => {
      this.element.querySelector('ul').classList.remove('opacity-0')
      this.element.querySelector('ul').classList.add('opacity-100')
    }, 1)
  }

  hide () {
    this.element.querySelector('ul').classList.remove('opacity-100')
    this.element.querySelector('ul').classList.add('opacity-0')
    this.hideTimeout = window.setTimeout(() => {
      this.element.querySelector('ul').classList.add('hidden')
    }, 500)
  }
}
