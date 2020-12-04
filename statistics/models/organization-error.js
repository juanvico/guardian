const mongoose = require('mongoose');

const schema = new mongoose.Schema({
  organization_id: String,
  month: Number,
  year: Number,
  count: Number,
});

module.exports = mongoose.model('organization_error', schema);
