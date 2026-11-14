const { app, BrowserWindow, ipcMain, dialog } = require('electron');
const path = require('path');
const { spawn } = require('child_process');

let mainWindow;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1200,
        height: 800,
        minWidth: 1000,
        minHeight: 700,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js'),
            contextIsolation: true,
            nodeIntegration: false,
            sandbox: true
        },
        titleBarStyle: 'hiddenInset',
        trafficLightPosition: { x: 15, y: 15 },
        icon: path.join(__dirname, '../assets/icon.png')
    });

    // Load Vite dev server in dev, built files in prod
    const isDev = process.env.NODE_ENV === 'development';
    if (isDev) {
        mainWindow.loadURL('http://localhost:5173');
        mainWindow.webContents.openDevTools();
    } else {
        mainWindow.loadFile(path.join(__dirname, '../dist/index.html'));
    }
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
});

// IPC Handlers for backend communication
ipcMain.handle('adb:connect', async (event, { ip, port }) => {
    return new Promise((resolve) => {
        const proc = spawn('adb', ['connect', `${ip}:${port}`]);
        let output = '';
        proc.stdout.on('data', (data) => output += data.toString());
        proc.stderr.on('data', (data) => output += data.toString());
        proc.on('close', (code) => resolve({ code, output }));
    });
});

ipcMain.handle('adb:run', async (event, args) => {
    return new Promise((resolve) => {
        const proc = spawn('adb', args);
        let output = '';
        proc.stdout.on('data', (data) => output += data.toString());
        proc.stderr.on('data', (data) => output += data.toString());
        proc.on('close', (code) => resolve({ code, output }));
    });
});

ipcMain.handle('script:run', async (event, { script, args, env }) => {
    return new Promise((resolve) => {
        const proc = spawn(script, args, { env: { ...process.env, ...env } });
        let output = '';
        proc.stdout.on('data', (data) => output += data.toString());
        proc.stderr.on('data', (data) => output += data.toString());
        proc.on('close', (code) => resolve({ code, output }));
    });
});

ipcMain.handle('dialog:openFile', async () => {
    const result = await dialog.showOpenDialog(mainWindow, {
        properties: ['openFile'],
        filters: [{ name: 'APK Files', extensions: ['apk'] }]
    });
    return result.filePaths[0];
});