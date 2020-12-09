const emailSender = require('../emails/email-sender');
const User = require('../models/user');

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

module.exports = {
  onErrorAssigned,
};
