const express = require('express');
const InvoiceController = require('../controllers/invoice-controller');
const router = express.Router();

router.get('/:organization_id', InvoiceController.getInvoiceByOrganizationAndDate);

module.exports = router;
