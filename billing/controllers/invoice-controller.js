const InvoiceService = require('../services/invoice-service');

const getInvoiceByOrganizationAndDate = async (req, res) => {
  if (req.headers['server-key'] !== process.env.SERVER_KEY) {
    return res.status(401).send('Unauthorized')
  }
  const { organization_id: orgId } = req.params;
  const { month, year } = req.query;

  const now = new Date();
  const invoice = await InvoiceService.getInvoice(orgId, +month || now.getMonth(), +year || now.getFullYear());

  return res.send({ invoice });
};

module.exports = {
  getInvoiceByOrganizationAndDate,
};
