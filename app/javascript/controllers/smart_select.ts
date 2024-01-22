import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";
import TomSelect from "tom-select";
import { post } from '@rails/request.js'
import { TomCreateCallback } from "tom-select/dist/types/types";

// Workaround for type issue: https://github.com/orchidjs/tom-select/issues/680
type TomCreate = (input: string, create: TomCreateCallback) => any

export default class SmartSelectController extends Controller<HTMLSelectElement> {
    static values = {
        create: Boolean,
        createUrl: String
    }

    declare smartSelect?: TomSelect
    declare createValue: boolean
    declare createUrlValue: string | undefined

    initialize(): void {
        this.createNewEntry = this.createNewEntry.bind(this)
    }

    connect() {
        useIntersection(this)
    }

    appear() {
        this.smartSelect = new TomSelect(this.element, {
            create: this.createValue ? this.createNewEntry as TomCreate : false
        });
    }

    async createNewEntry(input: string, callback: TomCreateCallback) {
        const response = await post(this.createUrlValue!, {
            responseKind: 'json',
            body: {
                ingredient: {
                    name: input
                }
            }
        })
        const data = await response.json
        if (response.ok) {
            callback({ value: data.id, text: data.name })
        } else {
            (data as Array<string>).forEach((error, index) => {
                setTimeout(() => {
                    this.notifyFailure(error)
                }, index > 0 ? 1000 : 0)
            })
        }
    }

    notifyFailure(error: string) {
        const container = document.getElementById("toasts_container");
        const toast = document.createElement("div");
        toast.classList.add("mt-3");
        toast.innerHTML = `
            <div data-controller="toasts">
                <div class="toast align-items-center text-bg-warning text-light border-0"
                     role="alert" aria-live="assertive" aria-atomic="true" data-toasts-target="toast">
                    <div class="d-flex">
                        <div class="toast-body">
                            ${error}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
            </div>
        `;
        container?.appendChild(toast);
    }
}
