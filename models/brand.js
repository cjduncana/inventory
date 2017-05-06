'use strict';

const Sequelize = require('sequelize');

module.exports = function(db) {
  const Brand = db.define('Brand', {
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
          where: { id: brand.id },
          fields: ['name']
        });
      }
    },

    tableName: 'brands'
  });

  return Brand;
};
