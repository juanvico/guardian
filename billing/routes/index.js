const express = require('express');
const errorsRouter = require('./errors');
const usersRouter = require('./users');
const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Statistics API');
});

router.use('/errors', errorsRouter);
router.use('/users', usersRouter);

module.exports = router;
