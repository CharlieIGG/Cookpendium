import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";
import TomSelect from "tom-select";

export default class SmartSelectController extends Controller<HTMLSelectElement> {
    connect() {
        useIntersection(this)
    }

    appear() {
        new TomSelect(this.element, {
            // Add your TomSelect options here
        });
    }
}
