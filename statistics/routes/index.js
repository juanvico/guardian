const express = require('express');
const statisticsRouter = require('./statistics');

const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Statistics API');
});

router.use('/statistics', statisticsRouter);

module.exports = router;
