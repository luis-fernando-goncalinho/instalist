import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["media", "icon"]

  connect() {
    //this.element.textContent = "Hello World!";
    console.log('connected')
  }

  select() {
    this.mediaTarget.classList.toggle("media-selected");
    this.iconTarget.classList.toggle("d-none");
  }
}
