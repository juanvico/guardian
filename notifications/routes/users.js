const express = require('express');
const UserController = require('../controllers/user-controller');
const router = express.Router();

router.get('/configuration/:user_id', UserController.getConfiguration);

module.exports = router;
