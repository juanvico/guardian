const StatisticsService = require('../services/statistics-service');

const getTop10DevelopersStatistics = async (req, res) => {
  const { org_id: orgId } = req.params;
  const statistics = await StatisticsService.getTop10DevelopersWithMostResolved(orgId);

  res.send(statistics);
};

const getUnassignedErrorsStatistics = async (req, res) => {
  const { org_id: orgId } = req.params; 
  const statistics = await StatisticsService.getOldUnassignedErrors(orgId);

  res.send(statistics);
};

const getErrorsBetweenDatesStatistics = async (req, res) => {
  const { org_id: orgId } = req.params;
  const { start, end } = req.query;

  const startDate = new Date(start);
  const endDate = new Date(end);

  console.log(startDate);
  console.log(endDate);

  const [errors, resolved, bySeverity] = await Promise.all([
    StatisticsService.getErrorsBetweenDates(orgId, startDate, endDate),
    StatisticsService.getResolvedErrorsBetweenDates(orgId, startDate, endDate),
    StatisticsService.getErrorsBetweenDatesBySeverity(orgId, startDate, endDate),
  ]);

  res.send({ errors, resolved, by_severity: bySeverity });
};

module.exports = {
  getTop10DevelopersStatistics,
  getUnassignedErrorsStatistics,
  getErrorsBetweenDatesStatistics,
};
