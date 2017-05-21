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
    },
    image: {
      type: Sequelize.STRING,
      allowNull: true
    }
  }, {
    classMethods: {
      getGoods: function() {
        return this.findAll({
          order: [['name', 'ASC']]
        });
      },

      findGood: function(id) {
        return this.findById(id, { paranoid: false });
      },

      createGood: function(good) {
        return this.create({
          name: good.name,
          image: good.image || null
        });
      },

      editGood: function(good) {
        return this.update(good, {
          where: { id: good.id },
          fields: ['name', 'image']
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
