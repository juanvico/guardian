const express = require('express');
const errorsRouter = require('./errors');
const statisticsRouter = require('./statistics');

const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Statistics API');
});

router.use('/errors', errorsRouter);
router.use('/statistics', statisticsRouter);

module.exports = router;
