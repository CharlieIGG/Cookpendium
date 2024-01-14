import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap";

class SmartRecipeFormController extends Controller {
  static targets = ["AIToolsToggle", "AIToolsInput", "nonAIFormInputs"];

  constructor(...args) {
    super(...args);
    this.loadingModal = window.lodmo = new Modal(document.getElementById('loadingModal'));
  }

  connect() {
    this.AIToolsToggleTarget.addEventListener('change', (e) => this.toggleAITools(e.target.checked));
    this.element.addEventListener('turbo:submit-start', () => this.showLoader());
    this.element.addEventListener('turbo:submit-end', () => this.hideLoader());
  }

  toggleAITools(checked) {
    if (checked) {
      this.AIToolsInputTarget.classList.remove('d-none');
      this.nonAIFormInputsTarget.classList.add('d-none');
    } else {
      this.AIToolsInputTarget.classList.add('d-none');
      this.nonAIFormInputsTarget.classList.remove('d-none');
      this.AIToolsInputTarget.value = '';
    }
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
    }, 5000);
  }

  hideLoader() {
    setTimeout(() => {
      this.loadingModal.hide();
    }, 500);
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-start', () => this.showLoader());
    this.element.removeEventListener('turbo:submit-end', () => this.hideLoader());
  }
}

export { SmartRecipeFormController }