const invoiceCreationJob = require('./invoice-creation-job');

const startJobs = () => {
  invoiceCreationJob.start();
};

module.exports = { startJobs };
