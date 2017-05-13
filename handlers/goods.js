'use strict';

module.exports = (ports, models) => {
  ports.getGoodsPort.subscribe(getGoods);

  ports.createGoodPort.subscribe(createGood);

  ports.editGoodPort.subscribe(editGood);

  ports.deleteGoodPort.subscribe(deleteGood);

  ports.destroyGoodPort.subscribe(destroyGood);

  ports.restoreGoodPort.subscribe(restoreGood);

  function createGood(name) {
    models.Good.createGood(name)
    .then(() => getGoods())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingGoodError(name);
      } else {
        sendError({ details: err.message });
      }
    });
  }

  function editGood(good) {
    models.Good.editGood(good)
    .then(() => getGoods())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingGoodError(good.name);
      } else {
        sendError({ details: err.message });
      }
    });
  }

  function deleteGood(goodId) {
    models.Good.deleteGood(goodId)
    .then(() => getGoods())
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function destroyGood(goodId) {
    models.Good.destroyGood(goodId)
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function restoreGood(goodId) {
    models.Good.restoreGood(goodId)
    .then(() => getGoods())
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function getGoods() {
    models.Good.getGoods()
    .then(ports.goodsReceivedPort.send)
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function existingGoodError(name) {
    sendError({
      errorType: 'duplicate_error',
      details: name + ' is already an existing Good'
    });
  }

  function sendError(error) {
    ports.errorReceivedPort.send(error);
  }
};
