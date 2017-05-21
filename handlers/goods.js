'use strict';

const { dialog } = require('electron').remote;
const fs = require('fs-extra');
const path = require('path');
const uuid = require('uuid');

const Promise = require('bluebird');

module.exports = (ports, models) => {
  ports.getGoodsPort.subscribe(getGoods);

  ports.createGoodPort.subscribe(createGood);

  ports.editGoodPort.subscribe(editGood);

  ports.deleteGoodPort.subscribe(deleteGood);

  ports.destroyGoodPort.subscribe(destroyGood);

  ports.restoreGoodPort.subscribe(restoreGood);

  ports.addFileDialogPort.subscribe(addFileDialog);

  ports.removeImage.subscribe(removeImage);

  function createGood(good) {
    models.Good.createGood(good)
    .then(() => getGoods())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingGoodError(good.name);
      } else {
        catchError(err);
      }
    });
  }

  function editGood(good) {
    models.Good.findGood(good.id)
    .then((original) => Promise.all([
      original,
      models.Good.editGood(good)
    ]))
    .spread((original) => {
      if (original.image) {
        return fs.remove(path.resolve('images', original.image));
      }

      return Promise.resolve();
    })
    .then(() => getGoods())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingGoodError(good.name);
      } else {
        catchError(err);
      }
    });
  }

  function deleteGood(goodId) {
    models.Good.deleteGood(goodId)
    .then(() => getGoods())
    .catch(catchError);
  }

  function destroyGood(goodId) {
    models.Good.findGood(goodId)
    .then((original) => Promise.all([
      original,
      models.Good.destroyGood(goodId)
    ]))
    .spread((original) => {
      if (original.image) {
        return fs.remove(path.resolve('images', original.image));
      }

      return Promise.resolve();
    })
    .catch(catchError);
  }

  function restoreGood(goodId) {
    models.Good.restoreGood(goodId)
    .then(() => getGoods())
    .catch(catchError);
  }

  function getGoods() {
    models.Good.getGoods()
    .then(ports.goodsReceivedPort.send)
    .catch(catchError);
  }

  function addFileDialog() {
    dialog.showOpenDialog({
      title: 'Choose an image',
      filters: [{
        name: 'Images',
        extensions: ['jpg', 'png', 'gif', 'svg']
      }]
    }, (filenames) => {
      if (filenames === undefined) {
        sendError({
          details: 'No file selected'
        });
      } else {
        const base = uuid.v4() + path.extname(filenames[0]);

        fs.copy(filenames[0], path.resolve('images', base))
        .then(() => {
          ports.imageSaved.send(base);
        })
        .catch(catchError);
      }
    });
  }

  function removeImage(filename) {
    return fs.remove(path.resolve('images', filename))
    .catch(catchError);
  }

  function existingGoodError(name) {
    sendError({
      errorType: 'duplicate_error',
      details: name + ' is already an existing Good'
    });
  }

  function catchError(error) {
    sendError({ details: error.message });
  }

  function sendError(error) {
    ports.errorReceivedPort.send(error);
  }
};
