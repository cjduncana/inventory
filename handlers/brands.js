'use strict';

const formatters = require('../lib/formatters');

module.exports = (ports, models) => {
  ports.getBrandsPort.subscribe(getBrands);

  ports.createBrandPort.subscribe(createBrand);

  ports.editBrandPort.subscribe(editBrand);

  ports.deleteBrandPort.subscribe(deleteBrand);

  function createBrand(name) {
    models.Brand.createBrand(name)
    .then(() => getBrands())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingBrandError(name);
      } else {
        sendError({ details: err.message });
      }
    });
  }

  function editBrand(brand) {
    models.Brand.editBrand(brand)
    .then(() => getBrands())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingBrandError(brand.name);
      } else {
        sendError({ details: err.message });
      }
    });
  }

  function deleteBrand(brandId) {
    models.Brand.deleteBrand(brandId)
    .then(() => getBrands())
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function getBrands() {
    models.Brand.getBrands()
    .map(formatters.brand)
    .then(ports.brandsRecievedPort.send)
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function existingBrandError(name) {
    sendError({
      details: name + ' is already an existing Brand',
      name
    });
  }

  function sendError(error) {
    ports.errorRecievedPort.send(error);
  }
};
