var mongoose = require('./db.js')

var Schema = mongoose.Schema;
var ObjectId = Schema.ObjectId;

var User = new Schema({
  id: ObjectId,
  token: String
}, {
  collection: 'User'
});

module.exports = mongoose.model('User', User);

