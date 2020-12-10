const express = require('express');
const usersRouter = require('./users');

const router = express.Router();

router.get('/', (_req, res) => {
  res.send('Notifications API');
});

router.use('/users', usersRouter);

module.exports = router;
