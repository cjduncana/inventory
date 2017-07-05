'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Report = db.define('Report', {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true
    },
    createdAt: {
      type: Sequelize.DATE
    },
    updatedAt: {
      type: Sequelize.DATE
    }
  }, {

    classMethods: {
      getReport: function(id) {
        return this.findById(id, {
          include: [{
            model: this.sequelize.models.Record,
            as: 'records',
            include: [{
              model: this.sequelize.models.ReportGood,
              as: 'good',
              include: [{
                model: this.sequelize.models.ReportBrand,
                as: 'brand'
              }, {
                model: this.sequelize.models.ReportMarket,
                as: 'markets'
              }]
            }]
          }]
        })
        .then((report) => report.records.map((record) => ({
          id: record.id,
          quantityStored: record.quantityStored,
          quantityUsed: record.quantityUsed,
          good: {
            id: record.good.id,
            name: record.good.name,
            image: record.good.image,
            brand: record.good.brand && {
              id: record.good.brand.id,
              name: record.good.brand.name
            } || null,
            markets: record.good.markets.map((market) => ({
              id: market.id,
              name: market.name
            }))
          }
        })));
      },

      getReports: function() {
        return this.findAll({
          order: [['createdAt', 'ASC']],
          include: [{
            model: this.sequelize.models.Record,
            as: 'records'
          }]
        })
        .map((report) => ({
          id: report.id,
          createdAt: report.createdAt.toString(),
          updatedAt: report.updatedAt.toString(),
          recordCount: report.records.length
        }));
      }
    },

    paranoid: true,
    tableName: 'reports'
  });

  return Report;
};

module.exports.associations = function({ Record, Report }) {
  Report.hasMany(Record, {
    as: 'records',
    foreignKey: 'reportId'
  });
};
