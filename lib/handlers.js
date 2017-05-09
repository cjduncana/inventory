'use strict';

const fs = require('fs');
const path = require('path');

const Models = require('../lib/models');

module.exports = (ports) => {

  const handlersPath = path.normalize(__dirname + '/../handlers');

  // Create the Database Models
  return Models.createModels()
  .then((models) => {

    fs.readdirSync(handlersPath).forEach((file) => {
      require(`${handlersPath}/${file}`)(ports, models);
    });
  });
};
