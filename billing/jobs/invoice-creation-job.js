const InvoiceService = require('../services/invoice-service');
const CronJob = require('cron').CronJob;

const START_OF_MONTH = '0 0 1 * *';

const job = new CronJob(START_OF_MONTH, () => {
  InvoiceService.createInvoices();
});

module.exports = job;
