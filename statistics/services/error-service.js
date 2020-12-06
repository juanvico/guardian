const ErrorModel = require('../models/error');

const addError = error => {
  const date = new Date();
  return ErrorModel.create({ ...error, date });
};

module.exports = {
  addError,
};
