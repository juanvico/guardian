const ErrorModel = require('../models/error');

const addError = error => {
  const date = new Date();
  return ErrorModel.create({ ...error, date });
};

const updateError = (errorId, error) => {
  return ErrorModel.updateOne(errorId, error);
};

module.exports = {
  addError,
  updateError,
};
