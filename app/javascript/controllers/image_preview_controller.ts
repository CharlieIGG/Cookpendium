import { Controller } from "@hotwired/stimulus";
import { HIDE_CLASS } from "../constants/css_manipulation";

export default class ImagePreviewController extends Controller {
    static targets = ["output", "input", "approval", "preview", "initiator"]

    declare inputTarget: HTMLInputElement;
    declare outputTargets: Array<HTMLImageElement>;
    declare approvalTarget?: Element
    declare hasApprovalTarget: boolean
    declare previewTargets: Array<Element>
    declare initiatorTarget?: Element
    declare hasInitiatorTarget: boolean

    readURL() {
        var input = this.inputTarget

        if (input.files && input.files[0]) {
            if (!this.validateImage(input.files[0])) return this.handleInvalidFile();

            var reader = new FileReader();

            reader.onload = () => {
                this.updateOutputSources(reader.result as string);
            }

            reader.readAsDataURL(input.files[0]);
            this.toggleOutputsAndPreviews(true);
            this.toggleApprovalTarget(true);
            this.toggleInitiatorTarget(false);
        }
    }

    handleInvalidFile() {
        alert("Invalid file type. Please upload a valid image file (jpg, jpeg, png, gif)");
        this.inputTarget.value = "";
        this.clearPreviews();
    }

    updateOutputSources(source: string) {
        this.outputTargets.forEach(output => output.src = source);
    }

    toggleOutputsAndPreviews(show: boolean) {
        const method = show ? 'remove' : 'add';
        this.outputTargets.forEach(output => output.classList[method](HIDE_CLASS));
        this.previewTargets.forEach(preview => preview.classList[method](HIDE_CLASS));
    }

    toggleApprovalTarget(show: boolean) {
        const method = show ? 'remove' : 'add';
        if (this.hasApprovalTarget) {
            this.approvalTarget?.classList[method](HIDE_CLASS);
        }
    }

    toggleInitiatorTarget(show: boolean) {
        const method = show ? 'remove' : 'add';
        if (this.hasInitiatorTarget) {
            this.initiatorTarget?.classList[method](HIDE_CLASS);
        }
    }

    validateImage(file: File): boolean {
        const allowedExtensions = ["jpg", "jpeg", "png", "gif"];
        const fileExtension = file.name.split(".").pop()?.toLowerCase();

        if (fileExtension && allowedExtensions.includes(fileExtension)) {
            return true;
        }

        return false;
    }

    clearPreviews() {
        this.updateOutputSources("");
        if (this.hasApprovalTarget) {
            this.toggleApprovalTarget(false);
        }
        if (this.hasInitiatorTarget) {
            this.toggleInitiatorTarget(true);
        }
    }

    clear(e: Event) {
        e.preventDefault();
        this.inputTarget.value = "";
        this.clearPreviews();
        this.toggleOutputsAndPreviews(false);
    }
}