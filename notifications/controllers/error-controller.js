const ErrorService = require('../services/error-service');
const NotifierService = require('../services/notifier-service');

const onErrorAdded = async (req, res) => {
  const { error_id: errorId } = req.params;
  const {
    severity,
    resolved,
    title,
    description,
    assigned_developer: assignedDeveloper,
    org_id: orgId,
  } = req.body;

  const basicError = {
    organization_id: orgId,
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    error_id: errorId,
  };

  await ErrorService.addError(basicError);
  NotifierService.onErrorAssigned({ ...basicError, title, description });

  res.send({ message: 'Error added successfully' });
};

const onErrorUpdated = async (req, res) => {
  const { error_id: errorId } = req.params;
  const {
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
  } = req.body;

  await ErrorService.updateError({ error_id: errorId }, {
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
  });

  res.send({ message: 'Error updated successfully' });
};

const onErrorResolved = async (req, res) => {
  const { error_id: errorId } = req.params;
  await ErrorService.updateError({ error_id: errorId }, { resolved: true });

  res.send({ message: 'Error resolved successfully' });
};

module.exports = {
  onErrorAdded,
  onErrorUpdated,
  onErrorResolved,
};
