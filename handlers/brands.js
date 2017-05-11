'use strict';

const formatters = require('../lib/formatters');

module.exports = (ports, models) => {
  ports.getBrandsPort.subscribe(getBrands);

  ports.createBrandPort.subscribe(createBrand);

  ports.editBrandPort.subscribe(editBrand);

  ports.deleteBrandPort.subscribe(deleteBrand);

  ports.destroyBrandPort.subscribe(destroyBrand);

  ports.restoreBrandPort.subscribe(restoreBrand);

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

  function destroyBrand(brandId) {
    models.Brand.destroyBrand(brandId)
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function restoreBrand(brandId) {
    models.Brand.restoreBrand(brandId)
    .then(() => getBrands())
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function getBrands() {
    models.Brand.getBrands()
    .map(formatters.brand)
    .then(ports.brandsReceivedPort.send)
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function existingBrandError(name) {
    sendError({
      errorType: 'duplicate_error',
      details: name + ' is already an existing Brand'
    });
  }

  function sendError(error) {
    ports.errorReceivedPort.send(error);
  }
};
