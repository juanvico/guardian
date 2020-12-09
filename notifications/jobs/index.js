const errorAmountNotificationJob = require('./error-amount-notification-job');
const unresolvedErrorsAmountNotificationJob = require('./unresolved-errors-amount-notification-job');

const startJobs = () => {
  errorAmountNotificationJob.start();
  unresolvedErrorsAmountNotificationJob.start();
};

module.exports = { startJobs };
