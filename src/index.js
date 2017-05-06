'use strict';

const { app, BrowserWindow } = require('electron');

// saves a global reference to mainWindow so it doesn't get garbage collected
let mainWindow;

// called when electron has initialized
app.on('ready', createWindow);

// This will create our app window, no surprise there
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1024,
    height: 768,
    show: false
  });

  // display the index.html file
  mainWindow.loadURL(`file://${ __dirname }/index.html`);

  // Open the DevTools.
  mainWindow.webContents.openDevTools();

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

/* Mac Specific things */

// when you close all the windows on a non-mac OS it quits the app
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// if there is no mainWindow it creates one (like when you click the dock icon)
app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});
