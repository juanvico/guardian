const ErrorService = require('../services/error-service');
const NotifierService = require('../services/notifier-service');

const onErrorAdded = async (errorBody) => {
  const {
    error_id: errorId,
    severity,
    resolved,
    title,
    description,
    assigned_developer: assignedDeveloper,
    organization_id: orgId,
  } = errorBody;

  const basicError = {
    organization_id: orgId,
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    error_id: errorId,
  };

  await ErrorService.addError(basicError);
  NotifierService.onErrorAssigned({ ...basicError, title, description });
};

const onErrorUpdated = async (errorBody) => {
  const {
    error_id: errorId,
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
  } = errorBody;

  await ErrorService.updateError({ error_id: errorId }, {
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
  });
};

const onErrorResolved = async (errorBody) => {
  const { error_id: errorId } = errorBody;
  await ErrorService.updateError({ error_id: errorId }, { resolved: true });
};

module.exports = {
  onErrorAdded,
  onErrorUpdated,
  onErrorResolved,
};
