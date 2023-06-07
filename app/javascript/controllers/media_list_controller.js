import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-list"
export default class extends Controller {

  static targets = ["list", "input", "add", "form"];

  connect() {
    console.log('Media list controller connected');
    window.addEventListener('scroll', this.handleScroll.bind(this));
  }

  handleScroll() {
    const scrollPosition = window.innerHeight + window.pageYOffset;
    const pageHeight = document.documentElement.offsetHeight;

    console.log('scroll!')

    if (scrollPosition >= pageHeight) {
      this.triggerEvent();
    }
  }

  triggerEvent() {
    // Trigger your desired event or function here
    console.log('Reached the end of the page!');
    let url = this.listTarget.dataset.nextUrl;
    let after = this.listTarget.dataset.afterUrl;
    const user_token = 'IGQVJVSTh1ZA3FnMm9GWXBjYXFLcm5yMk5GNHQ5YjJqUl95aU1qdGdtLTNRRU9tYmtpa2VuTDZAZARVJ1aHQ1ZAEhVVWNUWjVTeFBsZATl3R2wxVWhpUlpITGZASOWhJejRTY3R0WnZABdWxScjdIdFEteEt5dwZDZD'
    let limit = 24;
    let fields = `media_url,media_type,caption,permalink,timestamp,thumbnail_url`;

    let final_url = `${url}/media?access_token=${user_token}&fields=${fields}&limit${limit}&after=${after}`;



    fetch(final_url)
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
        //console.log(data);

        data.data.forEach((media) => {
          // depois trocar media_url por ternário do image_url
          let HTML = `<div class="position-relative" data-action="click->media-list#select">
          <div class="media-card" id="media"
            data-media="${JSON.stringify(media)}"
            style="background-image:url(${media.media_url})">
          </div>
          <div class="d-none icon-container" id="selected">
            <i class="fa-solid fa-circle-check fa-lg top-left-icon" style="color: #ff5252;"></i>
            <div class="icon-background top-left-icon-bg"></div>
          </div>
          <div class="d-none unselected-icon top-left-unselected-icon" id="unselected">
          </div>
        </div>`;
        this.listTarget.insertAdjacentHTML("beforeend", HTML)
        });
        console.dir(this.listTarget)
        // está sempre pegando a mesma URL, devemos mudar o outerHTML
        //this.listTarget.dataset.nextUrl = data.paging.next;
      })
      .catch(error => {
        // Handle any errors that occurred during the request
        //console.error(error);
        //alert('List name or selected medias cant be empty!')
      });



    // You can call a function or perform any action you want when the scroll reaches the end
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

  updateList(){
    const medias = this.getSelectedMedias();
    const listName = this.inputTarget.value;

    const url = this.formTarget.action;
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const data = {
      medias: medias,
      list_name: listName
    };

    const options = {
      method: 'PUT',
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
