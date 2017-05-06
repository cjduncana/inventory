'use strict';

const Elm = require('./elm.js');
const Handlers = require('../handlers');

// Get a reference to the DIV where we will show our UI
const container = document.getElementById('container');

// Start the elm app in the container
// and keep a reference for communicating with the app
const app = Elm.Main.embed(container);

// Load the handlers into the ports
Handlers(app.ports);
