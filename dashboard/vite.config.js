import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig({
    plugins: [vue()],
    root: 'src/renderer',
    base: './',
    build: {
        outDir: '../../dist',
        emptyOutDir: true,
        rollupOptions: {
            input: {
                main: path.resolve(__dirname, 'src/renderer/index.html')
            }
        }
    },
    resolve: {
        alias: {
            '@': path.resolve(__dirname, 'src/renderer')
        }
    },
    server: {
        port: 5173,
        strictPort: true
    }
});