const sgMail = require('@sendgrid/mail');

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const sendEmail = async ({ to, subject, message }) => {
  try {
    await sgMail.send({ to, from: process.env.EMAIL_FROM, subject, html: message });
  } catch (error) {
    console.error(error);
  }
};

module.exports = { sendEmail };
