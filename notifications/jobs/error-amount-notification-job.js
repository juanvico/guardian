const NotifierService = require('../services/notifier-service');
const CronJob = require('cron').CronJob;

const EVERY_MINUTE = '* * * * *';

const job = new CronJob(EVERY_MINUTE, () => {
  NotifierService.notifyErrorAmount();
});

module.exports = job;
