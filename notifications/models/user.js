const mongoose = require('mongoose');

const schema = new mongoose.Schema({
  user_id: String,
  organization_id: String,
  email: String,
  configuration: new mongoose.Schema({
    severity_filter: { type: Number, default: 1 },
    immediate_notification: { type: Boolean, default: false },
    daily_notification: { type: Boolean, default: false },
    daily_notification_time: { type: String, default: '12:00' },
  }),
});

module.exports = mongoose.model('user', schema);
