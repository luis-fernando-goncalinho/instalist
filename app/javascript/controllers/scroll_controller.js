import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  static targets = ["section"];

  connect() {
    console.log('Scroll controller connected');
  }

  initializeScrollify() {
    console.log('oi')
    $(this.element).scrollify({
      section: this.sectionTarget.join(", "),
      scrollSpeed: 800
    });
  }
}
