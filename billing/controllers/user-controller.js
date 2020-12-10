const UserService = require('../services/user-service');

const onUserAdded = async (req, res) => {
  const { organization_id: orgId } = req.params;
  await UserService.updateOrganizationUsers(orgId);

  res.send({ message: 'User added successfully' });
};

module.exports = {
  onUserAdded,
};
