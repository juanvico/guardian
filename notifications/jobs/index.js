const errorAmountNotificationJob = require('./error-amount-notification-job');

const startJobs = () => {
  errorAmountNotificationJob.start();
};

module.exports = { startJobs };
