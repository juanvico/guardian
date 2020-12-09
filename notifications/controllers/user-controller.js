const UserService = require('../services/user-service');

const onUserAdded = async (req, res) => {
  const { user_id: userId } = req.params;
  const {
    email,
    organization_id: orgId,
  } = req.body;

  await UserService.addUser({
    organization_id: orgId,
    user_id: userId,
    email,
    configuration: {},
  });

  res.send({ message: 'User added successfully' });
};

const onUserUpdated = async (req, res) => {
  const { user_id: userId } = req.params;
  const {
    email,
  } = req.body;

  await UserService.updateUser(userId, { email });

  res.send({ message: 'User updated successfully' });
};

const onConfigurationUpdated = async (req, res) => {
  const { user_id: userId } = req.params;
  const {
    severity_filter,
    immediate_notification,
    daily_notification,
    daily_notification_time,
  } = req.body;

  await UserService.updateConfiguration(userId, {
    severity_filter,
    immediate_notification,
    daily_notification,
    daily_notification_time,
  });

  res.send({ message: 'Configuration updated successfully' });
};

const getConfiguration = async (req, res) => {
  const { user_id: userId } = req.params;
  const configuration = await UserService.getConfiguration(userId);

  res.send({ configuration });
};

module.exports = {
  onUserAdded,
  onUserUpdated,
  onConfigurationUpdated,
  getConfiguration,
};
