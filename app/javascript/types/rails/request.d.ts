interface postOptions {
    body?: Object | Array,
    contentType?: string,
    headers?: Object,
    query?: Object,
    responseKind?: "html" | "turbo-stream" | "json"
}

declare module '@rails/request.js' {
    export function post(url: string, options?: postOptions): Promise<any>;
}