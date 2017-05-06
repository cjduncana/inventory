'use strict';

const Models = require('../lib/models');

module.exports = (ports) => {

  // Create the Database Models
  return Models.createModels()
  .then((models) => {
    const Brands = require('./brands')(ports, models);

    ports.getBrandsPort.subscribe(Brands.getBrands);

    ports.createBrandPort.subscribe(Brands.createBrand);

    ports.editBrandPort.subscribe(Brands.editBrand);

    ports.deleteBrandPort.subscribe(Brands.deleteBrand);
  });
};
