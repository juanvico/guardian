const { subMonths, subDays } = require('date-fns');
const ErrorModel = require('../models/error');

const getTop10DevelopersWithMostResolved = orgId => {
  return ErrorModel.aggregate([
    {
      $match: {
        date: { $gte: subMonths(new Date(), 1) },
        organization_id: orgId,
        resolved: true,
        assigned_developer: { $exists: true },
      }
    },
    {
      $group: {
        _id: '$assigned_developer',
        count: { $sum: 1 },
      }
    },
    { $limit: 10 },
  ]);
};

const getOldUnassignedErrors = async orgId => {
  const errors = await ErrorModel.find({
    assigned_developer: null,
    date: { $lte: subDays(new Date(), 2) },
    organization_id: orgId,
    resolved: false,
  });
  return errors.map(error => error.error_id);
};

const getErrorsBetweenDates = (orgId, start, end) => {
  return ErrorModel
    .find({ organization_id: orgId, date: { $gt: start, $lt: end } })
    .countDocuments();
};

const getResolvedErrorsBetweenDates = (orgId, start, end) => {
  return ErrorModel
    .find({ organization_id: orgId, date: { $gt: start, $lt: end }, resolved: true })
    .countDocuments();
};

const getErrorsBetweenDatesBySeverity = async (orgId, start, end) => {
  return ErrorModel.aggregate([
    {
      $match: {
        date: { $gt: start, $lt: end },
        organization_id: orgId,
      }
    },
    {
      $group: {
        _id: '$severity',
        count: { $sum: 1 }
      }
    },
  ]);
};

module.exports = {
  getTop10DevelopersWithMostResolved,
  getOldUnassignedErrors,
  getErrorsBetweenDates,
  getResolvedErrorsBetweenDates,
  getErrorsBetweenDatesBySeverity,
};
