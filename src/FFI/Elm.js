'use strict';

const Elm = require('./elm.js');
const Handlers = require('../lib/handlers');

// Start the elm app in the container
// and keep a reference for communicating with the app
exports.startElm = function() {
  return Elm.Main.fullscreen();
};

// Load the handlers into the ports
exports.createHandlers = function(app) {
  return function() {
    Handlers(app.ports);
  };
};
