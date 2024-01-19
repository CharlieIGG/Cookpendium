import { Controller } from '@hotwired/stimulus'

export default class NestedIngredientsController extends Controller {
    declare containerTarget: HTMLElement
    declare templateTarget: HTMLElement
    declare wrapperSelectorValue: string

    static targets = ['container', 'template']

    add(e: Event) {
        e.preventDefault()
        const content: string = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString())
        this.containerTarget.insertAdjacentHTML('beforeend', content)
    }

    remove(e: Event): void {
        e.preventDefault()

        const target = e.target as HTMLElement;
        const wrapper: HTMLElement | null = target.closest(this.wrapperSelectorValue)

        if (wrapper) {
            if (wrapper.dataset.newRecord === 'true') {
                wrapper.remove()
            } else {
                wrapper.style.display = 'none'

                const input: HTMLInputElement = wrapper.querySelector("input[name*='_destroy']")!
                input.value = '1'
            }
        }
    }
}
