import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["media", "selected", "unselected"]

  connect() {
    console.log('Media Selector controller connected')
  }

  select() {
    this.mediaTarget.classList.toggle("media-selected");
    this.selectedTarget.classList.toggle("d-none");
    this.unselectedTarget.classList.toggle("d-none");
  }
}
