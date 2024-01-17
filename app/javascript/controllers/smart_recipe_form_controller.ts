import { Context, Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap";

class SmartRecipeFormController extends Controller {
  static values = {
    loadingMessages: Array
  }
  static targets = ["AIToolsToggle", "AIToolsInput", "nonAIFormInputs", "AIInputGroup"];
  declare loadingModal: Modal;
  declare AIToolsToggleTarget: Element;
  declare AIInputGroupTarget: Element;
  declare nonAIFormInputsTarget: Element;
  declare AIToolsInputTarget: HTMLInputElement;
  declare loadingMessagesValue: Array<string>;

  constructor(context: Context) {
    super(context);
    const loadingModalElement = document.getElementById('loadingModal');
    if (loadingModalElement) {
      this.loadingModal = new Modal(loadingModalElement);
    }
  }

  connect() {
    this.AIToolsToggleTarget.addEventListener('change', (e) => this.toggleAITools((e.target as HTMLInputElement).checked));
    this.element.addEventListener('turbo:submit-start', () => this.showLoader());
    this.element.addEventListener('turbo:submit-end', () => this.hideLoader());
  }

  toggleAITools(checked: boolean) {
    if (checked) {
      this.AIInputGroupTarget.classList.remove('d-none');
      this.nonAIFormInputsTarget.classList.add('d-none');
    } else {
      this.AIInputGroupTarget.classList.add('d-none');
      this.nonAIFormInputsTarget.classList.remove('d-none');
      this.AIToolsInputTarget.value = '';
    }
  }

  showLoader() {
    this.loadingModal.show();
    this.iterate_messages();
  }

  iterate_messages() {
    const messages = this.loadingMessagesValue;
    const loadingModalBody = document.querySelector('#loadingModal .modal-body .modal-text');
    if (!loadingModalBody) return;

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