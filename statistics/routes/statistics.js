const express = require('express');
const StatisticsController = require('../controllers/statistics-controller');
const router = express.Router();

router.get('/top_10_developers/:org_id', StatisticsController.getTop10DevelopersStatistics);
router.get('/unassigned_errors/:org_id', StatisticsController.getUnassignedErrorsStatistics);
router.get('/resolved_errors/:org_id', StatisticsController.getErrorsBetweenDatesStatistics);

module.exports = router;
