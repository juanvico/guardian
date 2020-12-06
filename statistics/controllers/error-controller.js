const ErrorService = require('../services/error-service');

const onErrorAdded = async (req, res) => {
  const { org_id: orgId } = req.params;
  const {
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    error_id: errorId,
  } = req.body;

  await ErrorService.addError({
    organization_id: orgId,
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    error_id: errorId,
  });

  res.send({ message: 'Error added successfully' });
};

module.exports = {
  onErrorAdded,
};
