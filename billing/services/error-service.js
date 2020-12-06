const OrganizationError = require('../models/organization-error');

const updateOrganizationErrors = async orgId => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();

  return OrganizationError.updateOne(
    { year, month, organization_id: orgId },
    { $inc: { count: 1 } },
    { upsert: true },
  );
};

module.exports = {
  updateOrganizationErrors,
};
