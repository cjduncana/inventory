'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Brand = db.define('Brand', {
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
      getBrands: function() {
        return this.findAll({
          order: [['name', 'ASC']]
        });
      },

      createBrand: function(name) {
        return this.create({ name });
      },

      editBrand: function(brand) {
        return this.update(brand, {
          where: { id: brand.id }
        });
      },

      deleteBrand: function(id) {
        return this.destroy({ where: { id } });
      },

      destroyBrand: function(id) {
        return this.destroy({
          where: {
            id,
            deletedAt: { $ne: null }
          },
          force: true
        });
      },

      restoreBrand: function(id) {
        return this.restore({ where: { id } });
      }
    },

    paranoid: true,
    tableName: 'brands'
  });

  return Brand;
};
