const mongoose = require('mongoose');

const schema = new mongoose.Schema({
  organization_id: String,
  count: Number,
});

module.exports = mongoose.model('organization_user', schema);
