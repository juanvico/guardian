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

module.exports = {
  addUser,
  updateUser,
  updateConfiguration,
};
