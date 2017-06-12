'use strict';

module.exports = (ports, models) => {
  ports.getReportsPort.subscribe(getReports);

  ports.createReportPort.subscribe(createReport);

  function createReport(records) {
    models.Report.create()
    .then((report) => models.Record.createRecords(records, report))
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
