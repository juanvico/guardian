const ErrorService = require('../services/error-service');

const onErrorAdded = async (req, res) => {
  const { org_id: orgId } = req.params;
  const error = await ErrorService.updateOrganizationErrors(orgId);

  res.send({ error });
};

module.exports = {
  onErrorAdded,
};
