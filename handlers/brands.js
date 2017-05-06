'use strict';

const formatters = require('../lib/formatters');

module.exports = (ports, models) => {
  return {
    getBrands: () => {
      getBrands();
    },

    createBrand: (name) => {
      models.Brand.createBrand(name)
      .then(() => getBrands())
      .catch((err) => {
        if (err.name === 'SequelizeUniqueConstraintError') {
          existingBrandError(ports, name);
        } else {
          sendError(ports, { details: err.message });
        }
      });
    },

    editBrand: (brand) => {
      models.Brand.editBrand(brand)
      .then(() => getBrands())
      .catch((err) => {
        if (err.name === 'SequelizeUniqueConstraintError') {
          existingBrandError(ports, brand.name);
        } else {
          sendError(ports, { details: err.message });
        }
      });
    },

    deleteBrand: (brandId) => {
      models.Brand.deleteBrand(brandId)
      .then(() => getBrands())
      .catch((err) => {
        sendError(ports, { details: err.message });
      });
    }
  };

  function getBrands() {
    models.Brand.getBrands()
    .map(formatters.brand)
    .then(ports.brandsRecievedPort.send)
    .catch((err) => {
      sendError(ports, { details: err.message });
    });
  }
};

function existingBrandError(ports, name) {
  sendError(ports, {
    details: name + ' is already an existing Brand',
    name
  });
}

function sendError(ports, error) {
  ports.errorRecievedPort.send(error);
}
