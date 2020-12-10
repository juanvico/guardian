const InvoiceService = require('../services/invoice-service');

const getInvoiceByOrganizationAndDate = async (req, res) => {
  const { organization_id: orgId } = req.params;
  const { month, year } = req.query;

  const now = new Date();
  const invoice = await InvoiceService.getInvoice(orgId, +month || now.getMonth(), +year || now.getFullYear());

  res.send({ invoice });
};

module.exports = {
  getInvoiceByOrganizationAndDate,
};
