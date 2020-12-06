const ErrorService = require('../services/error-service');

const onErrorAdded = async (req, res) => {
  const { error_id: errorId } = req.params;
  const {
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    org_id: orgId,
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

const onErrorUpdated = async (req, res) => {
  const { error_id: errorId } = req.params;
  const {
    severity,
    assigned_developer: assignedDeveloper,
  } = req.body;

  await ErrorService.updateError({ error_id: errorId }, {
    severity,
    assigned_developer: assignedDeveloper,
  });

  res.send({ message: 'Error updated successfully' });
};

module.exports = {
  onErrorAdded,
  onErrorUpdated,
};
