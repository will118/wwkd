var Quote = require('./quote.js');
var fs = require('fs');

function loadDefaultIntoDb(cb) {
  var quotes = JSON.parse(fs.readFileSync('quotes_library.json', 'utf-8'));

  var count = 0;

  quotes.forEach(function(quote) {
    var q = new Quote();
    q.id = quote.id;
    q.source = quote.source;
    q.body = quote.body;
    q.shows = 0;
    q.ups = 0;
    q.downs = 0;
    q.save(function(err) {
      if (err) throw err;
      if (count++ == quotes.length-1) {
        cb();
      }
    });
  });

}

module.exports = { loadDefaultIntoDb: loadDefaultIntoDb };
