import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-list"
export default class extends Controller {

  static targets = ["list"];

  connect() {
    console.log('Media list controller connected');
  }

  getSelectedMedias() {
    //Select all html elements with .media-selected class
    const elements = this.listTarget.querySelectorAll(".media-selected");
    let selected_medias = [];

    elements.forEach((element) => {
      // Recover media data from dataset.media
      selected_medias.push(JSON.parse(element.dataset.media));
    });

    return selected_medias
  }

  createList() {

    const medias = this.getSelectedMedias();
    const listName = 'Teste';
    const url = '/lists';
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    console.dir(medias);

    const data = {
      medias: medias,
      list_name: listName
    };

    console.log(JSON.stringify(data));

    const options = {
      method: 'POST',
      headers: {
        'Accept': 'text/plain',
        'X-CSRF-Token': csrfToken,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    };

    fetch(url, options)
      .then(response => response.text())
      .then(data => {
        // Handle the response from the server
        console.log(data);
      })
      .catch(error => {
        // Handle any errors that occurred during the request
        console.error(error);
      });

  }
}
