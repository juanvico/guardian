const OrganizationUser = require('../models/organization-user');
const OrganizationError = require('../models/organization-error');
const Invoice = require('../models/invoice');
const { PRICE_PER_USER_IN_USD, PRICE_PER_ERROR_IN_USD } = require('../utils/constants');

const createInvoice = async orgId => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();

  const { count: userCount } = await OrganizationUser.findOne({ organization_id: orgId });
  const { count: errorCount } = await OrganizationError.findOne({ organization_id: orgId, year, month });
  const pricePerUser = PRICE_PER_USER_IN_USD;
  const pricePerError = PRICE_PER_ERROR_IN_USD;

  const price = calculatePrice(userCount, errorCount, pricePerUser, pricePerError);

  return Invoice.create({
    price,
    month,
    year,
    organization_id: orgId,
    error_count: errorCount,
    user_count: userCount,
    price_per_user: pricePerUser,
    price_per_error: pricePerError,
  });
};

const calculatePrice = (userCount, errorCount, pricePerUser, pricePerError) => {
  return userCount * pricePerUser + errorCount * pricePerError;
};

const createInvoices = async () => {
  const organizationIds = await OrganizationUser.distinct('organization_id');
  await Promise.all(organizationIds.map(orgId => createInvoice(orgId)));
};

module.exports = {
  createInvoices,
};
