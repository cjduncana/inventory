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
    classMethods: {
      getGoods: function() {
        return this.findAll({
          order: [['name', 'ASC']],
          include: [{
            model: this.sequelize.models.Brand,
            as: 'brand'
          }]
        });
      },

      findGood: function(id) {
        return this.findById(id, { paranoid: false });
      },

      createGood: function(good) {
        return this.create(good);
      },

      editGood: function(good) {
        return this.update(good, {
          where: { id: good.id }
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

module.exports.associations = function({ Brand, Good }) {
  Good.belongsTo(Brand, {
    as: 'brand',
    foreignKey: 'brandId'
  });
};
