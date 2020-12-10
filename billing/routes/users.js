const express = require('express');
const UserController = require('../controllers/user-controller');
const router = express.Router();

router.post('/:organization_id', UserController.onUserAdded);

module.exports = router;
