'use strict';

const Promise = require('bluebird');
const Sequelize = require('sequelize');

module.exports = function(db) {
  const ReportBrand = db.define('ReportBrand', {
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
      createReportBrand: function(good) {
        if (!good.brand) {
          return Promise.resolve();
        }

        return this.create({
          id: good.brand.id,
          goodId: good.id,
          name: good.brand.name
        });
      }
    },

    paranoid: true,
    tableName: 'report_brands'
  });

  return ReportBrand;
};
