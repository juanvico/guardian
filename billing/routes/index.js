const express = require('express');
const errorsRouter = require('./errors');
const usersRouter = require('./users');
const invoicesRouter = require('./invoices');

const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Billing API');
});

router.use('/errors', errorsRouter);
router.use('/users', usersRouter);
router.use('/invoices', invoicesRouter);

module.exports = router;
