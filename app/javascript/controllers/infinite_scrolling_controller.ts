import { Controller } from "@hotwired/stimulus";

export default class InfiniteScrollingController extends Controller {
    declare placeholderTemplateTarget: HTMLElement
    declare containerTarget: HTMLElement
    private placeholderStack: HTMLElement[] = [];

    static targets = ['placeholderTemplate', 'container']

    initialize(): void {
        this.handleFetchRequest = this.handleFetchRequest.bind(this);
        this.handleFetchResponse = this.handleFetchResponse.bind(this);
    }

    connect() {
        document.addEventListener('turbo:before-fetch-request', this.handleFetchRequest);
        document.addEventListener('turbo:before-fetch-response', this.handleFetchResponse);
    }

    disconnect() {
        document.removeEventListener('turbo:before-fetch-request', this.handleFetchRequest);
        document.removeEventListener('turbo:before-fetch-response', this.handleFetchResponse);
    }

    handleFetchRequest(_event: Event) {
        for (let i = 0; i < 3; i++) {
            const newNode = new DOMParser().parseFromString(this.placeholderTemplateTarget.innerHTML, 'text/html').body.firstChild;
            this.element.appendChild(newNode!);
            this.placeholderStack.push(newNode! as HTMLElement);
        }
    }

    handleFetchResponse(_event: Event) {
        for (let i = 0; i < 3; i++) {
            const lastNode = this.placeholderStack.pop();
            if (lastNode) {
                lastNode.remove();
            }
        }
    }
}