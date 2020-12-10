const express = require('express');
const StatisticsController = require('../controllers/statistics-controller');
const router = express.Router();

router.get('/:organization_id', StatisticsController.getOrganizationStatistics);

module.exports = router;
