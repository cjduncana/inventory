'use strict';

const Promise = require('bluebird');

const Database = require('./database');

let models;

module.exports = {
  getModels: function() {
    return models;
  },

  createModels: function() {
    if (models) {
      return Promise.resolve(models);
    }

    return Database.initialize()
    .then((models_) => {
      models = models_;
      return models;
    });
  }
};
