'use strict';

const Elm = require('./elm.js');

// Start the elm app in the container
// and keep a reference for communicating with the app
exports.startElm = function() {
  return Elm.Main.fullscreen();
};
