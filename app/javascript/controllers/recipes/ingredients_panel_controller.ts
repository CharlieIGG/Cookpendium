import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";

export default class IngredientsPanelController extends Controller {
    declare navBarElement: HTMLElement;
    declare bodyElement: HTMLElement;
    declare shouldCollapseValue: boolean;
    declare hasShouldCollapseValue: boolean;

    static values = {
        shouldCollapse: Boolean
    };

    connect(): void {
        super.connect();
        useIntersection(this);
        this.navBarElement = document.querySelector('.navbar')!;
        this.bodyElement = document.querySelector('body')!;
    }

    appear(): void {
        this.navBarElement.classList.add('navbar__with_ingredients_panel');
        this.bodyElement.classList.add('body__with_ingredients_panel');
    }

    disappear(): void {
        this.navBarElement.classList.remove('navbar__with_ingredients_panel');
        this.bodyElement.classList.remove('body__with_ingredients_panel');
    }

}
