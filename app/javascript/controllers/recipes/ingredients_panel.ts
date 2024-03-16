import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";

export default class IngredientsPanelController extends Controller {
    declare navBarElement: HTMLElement;
    declare bodyElement: HTMLElement;

    connect(): void {
        useIntersection(this);
        this.navBarElement = document.querySelector('.navbar')!;
        this.bodyElement = document.querySelector('body')!;
        if (window.innerWidth <= 768) {
            window.addEventListener('scroll', this.handleScroll);
        }
    }


    disconnect(): void {
        if (window.innerWidth <= 768) {
            window.removeEventListener('scroll', this.handleScroll);
        }
    }

    appear(): void {
        this.navBarElement.classList.add('navbar__with_ingredients_panel');
        this.bodyElement.classList.add('body__with_ingredients_panel');
    }

    disappear(): void {
        this.navBarElement.classList.remove('navbar__with_ingredients_panel');
        this.bodyElement.classList.remove('body__with_ingredients_panel');
    }

    handleScroll = (): void => {
        const elementRect = this.element.getBoundingClientRect();
        if (window.scrollY > elementRect.top + elementRect.height * 0.75) {
            (this.element as HTMLElement).classList.add('sticky-top');
            (this.element as HTMLElement).style.height = '25vh';
            (this.element as HTMLElement).style.top = document.getElementsByTagName('nav')[0].offsetHeight + 'px';
        } else {
            (this.element as HTMLElement).classList.remove('sticky-top');
            (this.element as HTMLElement).style.height = '';
            (this.element as HTMLElement).style.top = '';
        }
    };
}
