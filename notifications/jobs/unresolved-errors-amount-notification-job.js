const NotifierService = require('../services/notifier-service');
const CronJob = require('cron').CronJob;

const AT_MIDNIGHT = '0 0 * * *';

const job = new CronJob(AT_MIDNIGHT, () => {
  NotifierService.notifyUnresolvedAmount();
});

module.exports = job;
