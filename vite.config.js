import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    server: {
        host: 'localhost',
        port: 5173, // Asegúrate de usar el puerto correcto
        hmr: {
            host: 'localhost',
            protocol: 'ws',
        },
    },
    plugins: [
        laravel([
            'resources/js/app.js',
            'resources/css/app.css',
        ]),
    ],
});
