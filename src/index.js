'use strict';

const { app, BrowserWindow } = require('electron');

// Saves a global reference to mainWindow so it doesn't get garbage collected
let mainWindow;

// Called when electron has initialized
app.on('ready', createWindow);

// This will create our app window, no surprise there
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1024,
    height: 768,
    show: false
  });

  const splashScreen = new BrowserWindow({
    width: 1024,
    height: 768,
    parent: mainWindow,
    show: false
  });

  // Display the index.html file
  mainWindow.loadURL(`file://${ __dirname }/index.html`);

  // Display the splash screen
  splashScreen.loadURL(`file://${ __dirname }/splash-screen.html`);

  // Open the DevTools.
  mainWindow.webContents.openDevTools();

  splashScreen.once('ready-to-show', () => {
    splashScreen.show();
  });

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    splashScreen.hide();
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

/* Mac Specific things */

// When you close all the windows on a non-mac OS it quits the app
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// If there is no mainWindow it creates one (like when you click the dock icon)
app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});
