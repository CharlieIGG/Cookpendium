import { Controller } from "@hotwired/stimulus";
import { Toast } from 'bootstrap';

export default class ToastsController extends Controller {
    static targets = ["toast"];
    declare toast: Toast;
    declare toastTarget: Element;

    connect() {
        this.toast = new Toast(this.toastTarget, { delay: 7000 });
        this.toast.show();
    }

    disconnect() {
        this.toast.dispose();
    }
}