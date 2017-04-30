'use strict';

const Elm = require('./elm.js');

// get a reference to the div where we will show our UI
const container = document.getElementById('container');

// start the elm app in the container
// and keep a reference for communicating with the app
Elm.Main.embed(container);
