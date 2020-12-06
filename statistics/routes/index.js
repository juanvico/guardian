const express = require('express');
const errorsRouter = require('./errors');

const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Statistics API');
});

router.use('/errors', errorsRouter);

module.exports = router;
