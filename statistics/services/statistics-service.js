const { subMonths, subDays } = require('date-fns');
const ErrorModel = require('../models/error');

const getTop10DevelopersWithMostResolved = orgId => {
  return ErrorModel.aggregate([
    { $match: {
      date: { $gte: subMonths(new Date(), 1) },
      organization_id: orgId,
      resolved: true,
    } },
    { $group: {
      _id: '$assigned_developer',
      count: { $sum: 1 },
    } },
    { $limit: 10 },
  ]);
};

const getOldUnassignedErrors = async orgId => {
  const errors = await ErrorModel.find({
    assigned_developer: null,
    date: { $gte: subDays(new Date(), 2) },
    organization_id: orgId,
    resolved: false,
  });
  return errors.map(error => error.id);
};

const getErrorsBetweenDates = (orgId, start, end) => {
  return ErrorModel
    .find({ organization_id: orgId, date: { $gt: start, $lt: end } })
    .count();
};

const getResolvedErrorsBetweenDates = (orgId, start, end) => {
  return ErrorModel
    .find({ organization_id: orgId, date: { $gt: start, $lt: end }, resolved: true })
    .count();
};

const getErrorsBetweenDatesBySeverity = async (orgId, start, end) => {
  console.log(await ErrorModel.aggregate([
    { $match: {
      date: { $gt: start, $lt: end },
      organization_id: orgId,
    } }]));
  return ErrorModel.aggregate([
    { $match: {
      date: { $gt: start, $lt: end },
      organization_id: orgId,
    } },
    { $group: {
      _id: '$severity',
      count: { $sum: 1 },
    } },
  ]);
};

module.exports = {
  getTop10DevelopersWithMostResolved,
  getOldUnassignedErrors,
  getErrorsBetweenDates,
  getResolvedErrorsBetweenDates,
  getErrorsBetweenDatesBySeverity,
};
