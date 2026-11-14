import { createRouter, createWebHashHistory } from 'vue-router';

const routes = [
    { path: '/', redirect: '/dashboard' },
    { path: '/dashboard', component: { template: '<div>Dashboard</div>' } },
    { path: '/devices', component: { template: '<div>Devices</div>' } },
    { path: '/modules', component: { template: '<div>Modules</div>' } },
    { path: '/logs', component: { template: '<div>Logs</div>' } },
    { path: '/settings', component: { template: '<div>Settings</div>' } }
];

const router = createRouter({
    history: createWebHashHistory(),
    routes
});

export default router;