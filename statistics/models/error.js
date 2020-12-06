const mongoose = require('mongoose');

const schema = new mongoose.Schema({
  organization_id: String,
  date: Date,
  severity: Number,
  resolved: Boolean,
  assigned_developer: String,
  error_id: String,
});

module.exports = mongoose.model('error', schema);
