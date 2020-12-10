const express = require('express');
const ErrorController = require('../controllers/error-controller');
const router = express.Router();

router.post('/:organization_id', ErrorController.onErrorAdded);

module.exports = router;
