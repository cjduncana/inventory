'use strict';

const _ = require('lodash');
const Promise = require('bluebird');

module.exports = (ports, models) => {
  ports.getReportsPort.subscribe(getReports);

  ports.createReportPort.subscribe(createReport);

  function createReport(records) {
    const goodIds = _.chain(records).map('goodId').uniq().value();

    Promise.all([
      models.Report.create(),
      models.Good.findGoods(goodIds)
    ])
    .spread((report, goods) => Promise.map(records, (r) => {
      return models.Record.createRecord(r, report)
      .then((record) => {
        const good = goods.find(_.matchesProperty('id', r.goodId));

        if (!good) {
          return record.destroy({ force: true });
        }

        return Promise.all([
          models.ReportGood.createReportGood(good, record),
          models.ReportBrand.createReportBrand(good),
          models.ReportMarket.createReportMarkets(good)
        ]);
      });
    }))
    .then(() => getReports())
    .catch(catchError);
  }

  function getReports() {
    models.Report.getReports()
    .then(ports.reportsReceivedPort.send)
    .catch(catchError);
  }

  function catchError(error) {
    sendError({ details: error.message });
  }

  function sendError(error) {
    ports.errorReceivedPort.send(error);
  }
};
