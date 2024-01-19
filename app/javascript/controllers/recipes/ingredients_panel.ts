import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";

export default class IngredientsPanelController extends Controller {
    declare navBarElement: HTMLElement;

    connect(): void {
        useIntersection(this)
        this.navBarElement = document.querySelector('.navbar')!;
    }

    appear(): void {
        this.navBarElement.classList.add('navbar__with_ingredients_panel')
    }

    disappear(): void {
        this.navBarElement.classList.remove('navbar__with_ingredients_panel')
    }
}
