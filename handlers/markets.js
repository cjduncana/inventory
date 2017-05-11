'use strict';

const formatters = require('../lib/formatters');

module.exports = (ports, models) => {
  ports.getMarketsPort.subscribe(getMarkets);

  ports.createMarketPort.subscribe(createMarket);

  ports.editMarketPort.subscribe(editMarket);

  ports.deleteMarketPort.subscribe(deleteMarket);

  function createMarket(name) {
    models.Market.createMarket(name)
    .then(() => getMarkets())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingMarketError(name);
      } else {
        sendError({ details: err.message });
      }
    });
  }

  function editMarket(market) {
    models.Market.editMarket(market)
    .then(() => getMarkets())
    .catch((err) => {
      if (err.name === 'SequelizeUniqueConstraintError') {
        existingMarketError(market.name);
      } else {
        sendError({ details: err.message });
      }
    });
  }

  function deleteMarket(marketId) {
    models.Market.deleteMarket(marketId)
    .then(() => getMarkets())
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function getMarkets() {
    models.Market.getMarkets()
    .map(formatters.market)
    .then(ports.marketsReceivedPort.send)
    .catch((err) => {
      sendError({ details: err.message });
    });
  }

  function existingMarketError(name) {
    sendError({
      errorType: 'duplicate_error',
      details: name + ' is already an existing Market'
    });
  }

  function sendError(error) {
    ports.errorReceivedPort.send(error);
  }
};
