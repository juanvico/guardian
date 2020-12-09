const User = require('../models/user');

const addUser = async user => {
  return User.create(user);
};

const updateUser = (userId, user) => {
  return User.updateOne({ user_id: userId }, user);
};

const updateConfiguration = (userId, config) => {
  return User.updateOne({ user_id: userId }, { configuration: config });
};

const getConfiguration = async userId => {
  const user = await User.findOne({ user_id: userId });
  if (!user) return null;

  const {
    severity_filter,
    immediate_notification,
    daily_notification,
    daily_notification_time
  } = user.configuration;

  return {
    severity_filter,
    immediate_notification,
    daily_notification,
    daily_notification_time
  };
};

module.exports = {
  addUser,
  updateUser,
  updateConfiguration,
  getConfiguration,
};
