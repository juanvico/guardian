const express = require('express');
const UserController = require('../controllers/user-controller');
const router = express.Router();

router.post('/:user_id', UserController.onUserAdded);
router.patch('/configuration/:user_id', UserController.onConfigurationUpdated);
router.patch('/:user_id', UserController.onUserUpdated);

module.exports = router;
