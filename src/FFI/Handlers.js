'use strict';

const Models = require('../lib/models');

exports.createModelsImpl = function() {
  return Models.createModels();
};

exports.createHandlerImpl = function(models) {
  return function(app) {
    return function(path) {
      return function() {
        require('../handlers/' + path)(app.ports, models);
      };
    };
  };
};
