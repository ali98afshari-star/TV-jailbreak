const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
    adb: {
        connect: (ip, port) => ipcRenderer.invoke('adb:connect', { ip, port }),
        run: (args) => ipcRenderer.invoke('adb:run', args)
    },
    script: {
        run: (script, args, env) => ipcRenderer.invoke('script:run', { script, args, env })
    },
    dialog: {
        openFile: () => ipcRenderer.invoke('dialog:openFile')
    },
    onLog: (callback) => {
        ipcRenderer.on('log', (event, message) => callback(message));
    }
});