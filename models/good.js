'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Good = db.define('Good', {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true
    },
    name: {
      type: Sequelize.STRING,
      unique: true,
      allowNull: false
    },
    image: {
      type: Sequelize.STRING,
      allowNull: true
    },
    brandId: {
      type: Sequelize.UUID,
      allowNull: true
    }
  }, {
    instanceMethods: {
      removeImage: function() {
        this.image = null;
        return this.save()
        .then(() => this.reload());
      }
    },

    classMethods: {
      getGoods: function() {
        return this.findAll({
          order: [
            ['name', 'ASC'],
            [{
              model: this.sequelize.models.Market,
              as: 'markets'
            }, 'name', 'ASC']
          ],
          include: [{
            model: this.sequelize.models.Brand,
            as: 'brand'
          }, {
            model: this.sequelize.models.Market,
            as: 'markets'
          }]
        });
      },

      findGood: function(id) {
        return this.findById(id, { paranoid: false });
      },

      createGood: function(good) {
        return this.create(good)
        .then((g) => g.setMarkets(good.markets.map(({ id }) => id)));
      },

      editGood: function(good) {
        return this.findById(good.id)
        .then((g) => {
          g.name = good.name;
          g.image = good.image;
          g.brandId = good.brandId;

          return g.save()
          .then(() => g.setMarkets(good.markets.map(({ id }) => id)));
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

module.exports.associations = function({ Brand, Good, Market }) {
  Good.belongsTo(Brand, {
    as: 'brand',
    foreignKey: 'brandId'
  });

  Good.belongsToMany(Market, {
    as: 'markets',
    through: 'goods_markets',
    foreignKey: 'goodId'
  });
};
