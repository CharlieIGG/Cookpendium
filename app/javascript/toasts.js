import * as bootstrap from 'bootstrap';

document.addEventListener('turbo:load', () => {
    initializeToasts()
})

const initializeToasts = () => {
    const toastElList = document.querySelectorAll('.toast')
    const toastList = [...toastElList].map(toastEl => new bootstrap.Toast(toastEl))
    toastList.forEach(toast => toast.show())
}
