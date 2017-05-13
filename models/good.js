'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Good = db.define('Good', {
    id: {
      type: Sequelize.STRING,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true
    },
    name: {
      type: Sequelize.STRING,
      unique: true,
      allowNull: false
    }
  }, {
    classMethods: {
      getGoods: function() {
        return this.findAll({
          order: [['name', 'ASC']]
        });
      },

      createGood: function(name) {
        return this.create({ name });
      },

      editGood: function(good) {
        return this.update(good, {
          where: { id: good.id },
          fields: ['name']
        });
      },

      deleteGood: function(id) {
        return this.destroy({ where: { id } });
      },

      destroyGood: function(id) {
        return this.destroy({
          where: {
            id,
            deletedAt: { $ne: null }
          },
          force: true
        });
      },

      restoreGood: function(id) {
        return this.restore({ where: { id } });
      }
    },

    paranoid: true,
    tableName: 'goods'
  });

  return Good;
};
