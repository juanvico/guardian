const ErrorService = require('../services/error-service');

const onErrorAdded = async (req, res) => {
  const { org_id: orgId } = req.params;
  await ErrorService.updateOrganizationErrors(orgId);

  res.send({ message: 'Error added successfully' });
};

module.exports = {
  onErrorAdded,
};
