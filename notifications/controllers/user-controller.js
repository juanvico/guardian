const UserService = require('../services/user-service');

const onUserAdded = async (userBody) => {
  const {
    user_id: userId,
    email,
    organization_id: orgId,
  } = userBody;

  await UserService.addUser({
    organization_id: orgId,
    user_id: userId,
    email,
    configuration: {},
  });

};

const onUserUpdated = async (userBody) => {
  const {
    user_id: userId,
    email,
  } = userBody;

  await UserService.updateUser(userId, { email });
};

const onConfigurationUpdated = async (configurationBody) => {
  const {
    user_id: userId,
    severity_filter,
    immediate_notification,
    daily_notification,
    daily_notification_time,
  } = configurationBody;

  await UserService.updateConfiguration(userId, {
    severity_filter,
    immediate_notification,
    daily_notification,
    daily_notification_time,
  });
};

const getConfiguration = async (req, res) => {
  if (req.headers['server-key'] !== process.env.SERVER_KEY) {
    return res.status(401).send('Unauthorized')
  }
  const { user_id: userId } = req.params;
  const configuration = await UserService.getConfiguration(userId);

  return res.send({ configuration });
};

module.exports = {
  onUserAdded,
  onUserUpdated,
  onConfigurationUpdated,
  getConfiguration,
};
