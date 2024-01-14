import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap";

class SmartRecipeFormController extends Controller {
  constructor(...args) {
    super(...args);
    this.loadingModal = window.lodmo = new Modal(document.getElementById('loadingModal'));
  }

  connect() {
    this.element.addEventListener('turbo:submit-start', () => this.showLoader());
    this.element.addEventListener('turbo:submit-end', () => this.hideLoader());
  }

  showLoader() {
    this.loadingModal.show();
    this.iterate_messages();
  }

  iterate_messages() {
    const messages = [
      "Analyzing Recipe...",
      "Checking Title and Description...",
      "Identifying Ingredients...",
      "Identifying Instructions...",
      "Associating Ingredients and Steps...",
      "Importing into Recipes Database...",
    ];

    const loadingModalBody = document.querySelector('#loadingModal .modal-body .modal-text');
    loadingModalBody.textContent = messages[0];
    let index = 1;
    const intervalId = setInterval(() => {
      loadingModalBody.textContent = messages[index];
      index++;

      if (index === messages.length) {
        clearInterval(intervalId);
      }
    }, 3000);
  }

  hideLoader() {
    this.loadingModal.hide();
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-start', () => this.showLoader());
    this.element.removeEventListener('turbo:submit-end', () => this.hideLoader());
  }
}

export { SmartRecipeFormController }