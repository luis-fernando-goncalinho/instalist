import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-list"
export default class extends Controller {

  static targets = ["list", "input", "add"];

  connect() {
    console.log('Media list controller connected');
  }

  select(event) {
    const element = event.currentTarget;
    element.querySelector('#media').classList.toggle("media-selected");
    element.querySelector('#selected').classList.toggle("d-none");
    element.querySelector('#unselected').classList.toggle("d-none");

    //Logic to disable add button if no media is selected
    let select_count = this.getSelectedMedias().length
    if (select_count > 0) {
      this.addTarget.classList.remove('disabled');
      this.addTarget.innerText = `Adicionar (${select_count})`;
    }
    else {
      this.addTarget.classList.add('disabled');
      this.addTarget.innerText = `Adicionar`;
    }
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
    const listName = this.inputTarget.value;

    const url = '/lists';
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const data = {
      medias: medias,
      list_name: listName
    };

    const options = {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': csrfToken,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    };

    console.log(data);
    console.log(url);
    fetch(url, options)
      .then(response => {
        console.log(response);
        if (response.ok) {
          return response.json();
        } else {
          throw new Error(response.statusText)
        }
      })
      .then(data => {
        // Handle the response from the server
        console.log(data);
        window.location.href = `/lists/${data.list_id}`;
      })
      .catch(error => {
        // Handle any errors that occurred during the request
        console.error(error);
        alert('List name or selected medias cant be empty!')
      });
  }
}
