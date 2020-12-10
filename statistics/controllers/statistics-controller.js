const StatisticsService = require('../services/statistics-service');

const getOrganizationStatistics = async (req, res) => {
  if (req.headers['server-key'] !== process.env.SERVER_KEY) {
    return res.status(401).send('Unauthorized')
  }
  const { organization_id: orgId } = req.params;
  const { start, end } = req.query;
  const developersWithMostResolved = await getTop10DevelopersStatistics(orgId)
  const unsignedErrors = await getUnassignedErrorsStatistics(orgId)
  const { errors, resolved, by_severity } = await getErrorsBetweenDatesStatistics(orgId, start, end)

  return res.send({
    total_errors: errors,
    resolved,
    by_severity,
    unassigned_errors: unsignedErrors,
    top_developers: developersWithMostResolved
  })
}

const getTop10DevelopersStatistics = async (orgId) => {
  const developersWithMostResolved = await StatisticsService.getTop10DevelopersWithMostResolved(orgId);
  return developersWithMostResolved;
};

const getUnassignedErrorsStatistics = async (orgId) => {
  const unsignedErrors = await StatisticsService.getOldUnassignedErrors(orgId);
  return unsignedErrors;
};

const getErrorsBetweenDatesStatistics = async (orgId, start, end) => {
  const startDate = new Date(start);
  const endDate = new Date(end);

  const [errors, resolved, bySeverity] = await Promise.all([
    StatisticsService.getErrorsBetweenDates(orgId, startDate, endDate),
    StatisticsService.getResolvedErrorsBetweenDates(orgId, startDate, endDate),
    StatisticsService.getErrorsBetweenDatesBySeverity(orgId, startDate, endDate),
  ]);

  return ({ errors, resolved, by_severity: bySeverity });
};

module.exports = {
  getOrganizationStatistics
};
