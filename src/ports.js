'use strict';

const Elm = require('./elm.js');
const formatters = require('../lib/formatters');

const Models = require('../lib/models');

// Create the Database Models
Models.createModels()
.then((models) => {
  // get a reference to the div where we will show our UI
  const container = document.getElementById('container');

  // start the elm app in the container
  // and keep a reference for communicating with the app
  const app = Elm.Main.embed(container);

  app.ports.getBrands.subscribe(() => {
    models.Brand.getBrands()
    .map(formatters.brand)
    .then(app.ports.brandsRecieved.send);
  });

  app.ports.createBrand.subscribe((name) => {
    models.Brand.createBrand(name)
    .then(() => {
      return models.Brand.getBrands();
    })
    .map(formatters.brand)
    .then(app.ports.brandsRecieved.send);
  });
});
