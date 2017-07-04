'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Record = db.define('Record', {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true
    },
    reportId: {
      type: Sequelize.UUID,
      allowNull: false
    },
    quantityStored: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    quantityUsed: {
      type: Sequelize.INTEGER,
      allowNull: false
    }
  }, {

    classMethods: {
      createRecord: function(record, report) {
        record.reportId = report.id;

        return this.create(record);
      }
    },

    paranoid: true,
    tableName: 'records'
  });

  return Record;
};
