import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["media", "icon"]

  connect() {
    console.log('Media Selector controller connected')
  }

  select() {
    this.mediaTarget.classList.toggle("media-selected");
    this.iconTarget.classList.toggle("d-none");
  }
}
