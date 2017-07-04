'use strict';

const Promise = require('bluebird');
const Sequelize = require('sequelize');

module.exports = function(db) {
  const ReportMarket = db.define('ReportMarket', {
    id: {
      type: Sequelize.UUID,
      primaryKey: true
    },
    goodId: {
      type: Sequelize.UUID,
      allowNull: false
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false
    }
  }, {
    classMethods: {
      createReportMarkets: function(good) {
        return Promise.map(good.markets, (market) => {
          return this.create({
            id: market.id,
            goodId: good.id,
            name: market.name
          });
        });
      }
    },

    paranoid: true,
    tableName: 'report_markets'
  });

  return ReportMarket;
};
