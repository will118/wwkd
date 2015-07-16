var mongoose = require('./db.js')

var Schema = mongoose.Schema;

var Quote = new Schema({
  id: Number,
  source: String,
  body: String,
  shows: Number,
  ups: Number,
  downs: Number
}, {
  collection: 'Quote'
});

module.exports = mongoose.model('Quote', Quote);

