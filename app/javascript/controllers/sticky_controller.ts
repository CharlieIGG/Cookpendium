import { Controller } from "@hotwired/stimulus";

export default class StickyController extends Controller {
    declare shouldCollapseValue: boolean;
    declare hasShouldCollapseValue: boolean;
    navBarElement?: HTMLElement;
    isLocked = false;

    static values = {
        shouldCollapse: Boolean
    };

    connect(): void {
        if (window.innerWidth <= 768) {
            this.assignNavBarElement();
            this.setBaseStyles();
            window.addEventListener('scroll', this.handleScroll);
        }
    }


    disconnect(): void {
        window.removeEventListener('scroll', this.handleScroll);
    }

    assignNavBarElement(): void {
        let navBarElement = document.querySelector('nav');
        if (navBarElement) {
            this.navBarElement = navBarElement as HTMLElement;
        } else {
            throw new Error("Sticky Controller: Navbar element not found");
        }
    }

    setBaseStyles(): void {
        (this.element as HTMLElement).style.zIndex = '1';
        (this.element as HTMLElement).style.position = 'sticky';
        (this.element as HTMLElement).style.top = this.navBarElement!.offsetHeight + 'px';
        const transitionValue = (this.element as HTMLElement).style.transition ? (this.element as HTMLElement).style.transition + ', max-height 0.3s' : 'max-height 0.3s';
        (this.element as HTMLElement).style.transition = transitionValue
    }

    handleScroll = (): void => {
        if (this.isLocked) return;


        if (this.hasShouldCollapseValue && this.shouldCollapseValue) {
            this.isLocked = true;
            this.handleCollapse();
            setTimeout(() => {
                this.isLocked = false;
            }, 100);
        }
    };

    handleCollapse = (): void => {
        const elementRect = this.element.getBoundingClientRect();
        if (window.scrollY > elementRect.top + elementRect.height * 0.75) {
            this.collapse();
        } else {
            this.restore();
        }
    }

    collapse = (): void => {
        (this.element as HTMLElement).classList.add('max-vh-25');
        (this.element as HTMLElement).classList.add('sticky-collapsed');
        (this.element as HTMLElement).classList.remove('max-vh-100');
    }

    restore = (): void => {
        (this.element as HTMLElement).classList.add('max-vh-100');
        (this.element as HTMLElement).classList.remove('max-vh-25');
        (this.element as HTMLElement).classList.remove('sticky-collapsed');
    }
}
