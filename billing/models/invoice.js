const mongoose = require('mongoose');

const schema = new mongoose.Schema({
  organization_id: String,
  month: Number,
  year: Number,
  price: Number,
  user_count: Number,
  error_count: Number,
  price_per_user: Number,
  price_per_error: Number,
});

module.exports = mongoose.model('invoice', schema);
