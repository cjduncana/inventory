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
