const express = require('express');
const errorController = require('../controllers/error-controller');
const router = express.Router();

router.post('/:org_id', errorController.onErrorAdded);

module.exports = router;
