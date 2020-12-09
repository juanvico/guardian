const { format, subDays } = require('date-fns');

const emailSender = require('../emails/email-sender');
const User = require('../models/user');
const ErrorModel = require('../models/error');

const onErrorAssigned = async error => {
  if (error.resolved) return;

  const user = await User.findOne(error.assignedDeveloper);
  if (!user) return;

  const {
    immediate_notification: immediateNotification,
    severity_filter: severityFilter,
  } = user.configuration;

  if (!immediateNotification || error.severity > severityFilter) return;

  emailSender.sendEmail({
    to: user.email,
    subject: 'Guardian - New error',
    message: `
      <div style='background-color: #00173d; color: #fff; border-radius: 20px; margin: 15px; padding: 25px;'>
        <strong style='font-size: 22px;'>${error.title}</strong>
        <br />
        <p style='color: #d4d4d4;'>${error.description}</p>
        <hr />
        <p style='font-size: 12px; color: #d4d4d4;'>Severity: ${error.severity}</p>
      </div>
    `,
  });
};

const notifyErrorAmount = async () => {
  const date = new Date();
  const users = await User.find({ 'configuration.daily_notification_time': format(date, 'HH:mm') });

  await Promise.all(users.map(user => notifyErrorAmountPerUser(user, date)));
};

const notifyErrorAmountPerUser = async (user, date) => {
  const errorAmount = await ErrorModel
    .find({ date: { $gte: subDays(date, 1) }, severity: { $lte: user.configuration.severity_filter } })
    .countDocuments();
  
  if (!errorAmount) return;
  await sendErrorAmountEmail(user, errorAmount);
};

sendErrorAmountEmail = async (user, errorAmount) => {
  emailSender.sendEmail({
    to: user.email,
    subject: `Guardian - ${errorAmount} new errors`,
    message: `
      <div style='background-color: #00173d; color: #fff; border-radius: 20px; margin: 15px; padding: 25px;'>
        <strong style='font-size: 25px; margin-top: 15px; margin-bottom: 15px;'>
          There were ${errorAmount} new errors in the last 24 hours
        </strong>
      </div>
    `,
  });
};

const notifyUnresolvedAmount = async () => {
  const users = await User.find();
  const now = new Date();

  await Promise.all(users.map(user => notifyUnresolvedAmountPerUser(user, now)));
};

const notifyUnresolvedAmountPerUser = async (user, date) => {
  const errorAmount = await ErrorModel
    .find({ date: { $lte: subDays(date, 2) }, assigned_developer: user.user_id, resolved: false })
    .countDocuments();
  console.log(errorAmount);
  
  if (!errorAmount) return;
  await sendUnresolvedAmountEmail(user, errorAmount);
};

sendUnresolvedAmountEmail = async (user, errorAmount) => {
  emailSender.sendEmail({
    to: user.email,
    subject: `Guardian - ${errorAmount} unresolved errors`,
    message: `
      <div style='background-color: #00173d; color: #fff; border-radius: 20px; margin: 15px; padding: 25px;'>
        <strong style='font-size: 25px; margin-top: 15px; margin-bottom: 15px;'>
          You have ${errorAmount} unresolved errors assigned!
        </strong>
      </div>
    `,
  });
};

module.exports = {
  onErrorAssigned,
  notifyErrorAmount,
  notifyUnresolvedAmount,
};
