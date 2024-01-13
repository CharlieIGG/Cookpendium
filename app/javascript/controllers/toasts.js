import { Controller } from "@hotwired/stimulus";
import { Toast } from 'bootstrap';

class ToastsController extends Controller {
    static targets = ["toast"];

    connect() {
        this.toast = new Toast(this.toastTarget, { delay: 7000 });
        this.toast.show();
    }

    disconnect() {
        this.toast.dispose();
    }
}

export { ToastsController };
