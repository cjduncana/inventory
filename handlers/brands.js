'use strict';

const formatters = require('../lib/formatters');

module.exports = (ports, models) => {
  return {
    getBrands: () => {
      getBrands();
    },

    createBrand: (name) => {
      models.Brand.createBrand(name)
      .then(() => getBrands());
    },

    editBrand: (brand) => {
      models.Brand.editBrand(brand)
      .then(() => getBrands());
    }
  };

  function getBrands() {
    models.Brand.getBrands()
    .map(formatters.brand)
    .then(ports.brandsRecieved.send);
  }
};
