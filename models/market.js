'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Market = db.define('Market', {
    id: {
      type: Sequelize.UUID,
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
      getMarkets: function() {
        return this.findAll({
          order: [['name', 'ASC']]
        });
      },

      createMarket: function(name) {
        return this.create({ name });
      },

      editMarket: function(market) {
        return this.update(market, {
          where: { id: market.id }
        });
      },

      deleteMarket: function(id) {
        return this.destroy({ where: { id } });
      },

      destroyMarket: function(id) {
        return this.destroy({
          where: {
            id,
            deletedAt: { $ne: null }
          },
          force: true
        });
      },

      restoreMarket: function(id) {
        return this.restore({ where: { id } });
      }
    },

    paranoid: true,
    tableName: 'markets'
  });

  return Market;
};

module.exports.associations = function({ Good, Market }) {
  Market.belongsToMany(Good, {
    as: 'goods',
    through: 'goods_markets',
    foreignKey: 'marketId'
  });
};
