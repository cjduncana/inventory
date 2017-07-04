'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const ReportGood = db.define('ReportGood', {
    id: {
      type: Sequelize.UUID,
      primaryKey: true
    },
    recordId: {
      type: Sequelize.UUID,
      allowNull: false
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false
    },
    image: {
      type: Sequelize.STRING,
      allowNull: true
    }
  }, {
    classMethods: {
      createReportGood: function(good, record) {
        return this.create({
          id: good.id,
          recordId: record.id,
          name: good.name,
          image: good.image
        });
      }
    },

    paranoid: true,
    tableName: 'report_goods'
  });

  return ReportGood;
};
