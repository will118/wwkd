var db = require('mongoose/');

db.connect('mongodb://localhost/wwkd');

module.exports = db;
