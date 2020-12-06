const express = require('express');
const ErrorController = require('../controllers/error-controller');
const router = express.Router();

router.post('/:error_id', ErrorController.onErrorAdded);
router.patch('/:error_id', ErrorController.onErrorUpdated);
router.patch('/:error_id/resolved', ErrorController.onErrorResolved);

module.exports = router;
