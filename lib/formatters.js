'use strict';

function brand(brand) {
  return {
    id: brand.id,
    name: brand.name
  };
}

function market(market) {
  return {
    id: market.id,
    name: market.name
  };
}

module.exports = {
  brand,
  market
};
