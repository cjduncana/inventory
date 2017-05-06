'use strict';

const Models = require('../lib/models');

module.exports = (ports) => {

  // Create the Database Models
  return Models.createModels()
  .then((models) => {
    const Brands = require('./brands')(ports, models);

    ports.getBrands.subscribe(Brands.getBrands);

    ports.createBrand.subscribe(Brands.createBrand);

    ports.editBrand.subscribe(Brands.editBrand);
  });
};
