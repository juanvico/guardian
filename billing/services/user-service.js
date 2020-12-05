const OrganizationUser = require('../models/organization-user');

const updateOrganizationUsers = async orgId => {
  return OrganizationUser.updateOne(
    { organization_id: orgId },
    { $inc: { count: 1 } },
    { upsert: true },
  );
};

module.exports = {
  updateOrganizationUsers,
};
