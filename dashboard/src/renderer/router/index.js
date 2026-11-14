import { createRouter, createWebHashHistory } from 'vue-router';

const routes = [
    { path: '/', redirect: '/dashboard' },
    { path: '/dashboard', component: () => import('@/views/Dashboard.vue') },
    { path: '/devices', component: () => import('@/views/Devices.vue') },
    { path: '/modules', component: () => import('@/views/Modules.vue') },
    { path: '/logs', component: () => import('@/views/Logs.vue') },
    { path: '/settings', component: () => import('@/views/Settings.vue') }
];

const router = createRouter({
    history: createWebHashHistory(),
    routes
});

export default router;