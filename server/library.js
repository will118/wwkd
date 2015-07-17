var Quote = require('./quote.js');
var utils = require('./utils.js');

function getQuote(cb) {
  Quote.find(function(err, quotes) {
    if (err) throw err;
    if (quotes.length < 1) {
      console.log('No quotes in db, will attempt to load defaults and retry this function.');
      utils.loadDefaultIntoDb(function() { getQuote(cb) });
    } else {
      cb(quotes[Math.floor(Math.random()*quotes.length)])
    }
  })
}

module.exports = { getQuote: getQuote }
