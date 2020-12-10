const express = require('express');
const invoicesRouter = require('./invoices');

const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Billing API');
});

router.use('/invoices', invoicesRouter);

module.exports = router;
