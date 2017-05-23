'use strict';

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
        catchError(err);
      }
    });
  }

  function editBrand(brand) {
    models.Brand.editBrand(brand)
    .then(() => getBrands())
    .then(() => getGoods())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingBrandError(brand.name);
      } else {
        catchError(err);
      }
    });
  }

  function deleteBrand(brandId) {
    models.Brand.deleteBrand(brandId)
    .then(() => getBrands())
    .catch(catchError);
  }

  function destroyBrand(brandId) {
    models.Brand.destroyBrand(brandId)
    .catch(catchError);
  }

  function restoreBrand(brandId) {
    models.Brand.restoreBrand(brandId)
    .then(() => getBrands())
    .catch(catchError);
  }

  function getBrands() {
    models.Brand.getBrands()
    .then(ports.brandsReceivedPort.send)
    .catch(catchError);
  }

  function getGoods() {
    models.Good.getGoods()
    .then(ports.goodsReceivedPort.send)
    .catch(catchError);
  }

  function existingBrandError(name) {
    sendError({
      errorType: 'duplicate_error',
      details: name + ' is already an existing Brand'
    });
  }

  function catchError(error) {
    sendError({ details: error.message });
  }

  function sendError(error) {
    ports.errorReceivedPort.send(error);
  }
};
