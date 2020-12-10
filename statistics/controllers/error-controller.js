const ErrorService = require('../services/error-service');

const onErrorAdded = async (errorBody) => {
  const {
    error_id: errorId,
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    organization_id: orgId,
  } = errorBody;

  await ErrorService.addError({
    organization_id: orgId,
    severity,
    resolved,
    assigned_developer: assignedDeveloper,
    error_id: errorId,
  });
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
