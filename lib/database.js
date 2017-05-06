'use strict';

const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');

function initialize() {

  const sequelize = new Sequelize('sqlite:mydb.sqlite3', {
    dialect: 'sqlite',
    storage: path.resolve(__dirname, 'mydb.sqlite3')
  });

  const modelsPath = path.normalize(__dirname + '/../models');

  const modelFiles = fs.readdirSync(modelsPath);

  modelFiles.forEach((file) => {
    require(`${modelsPath}/${file}`)(sequelize);
  });

  return sequelize.sync()
  .then((db) => {

    modelFiles.forEach((file) => {
      const associations = require(`${modelsPath}/${file}`).associations;
      associations && associations(db.models);
    });

    return db.models;
  });
}

module.exports = { initialize };
