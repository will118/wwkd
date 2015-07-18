var Quote = require('./quote.js');
var utils = require('./utils.js');

function getQuote(cb) {
  Quote.find(function(err, quotes) {
    if (err) throw err;
    if (quotes.length < 1) {
      console.log('No quotes in db, will attempt to load defaults and retry this function.');
      utils.loadDefaultIntoDb(function() { getQuote(cb); });
    } else {
      cb(quotes[Math.floor(Math.random()*quotes.length)]);
    }
  });
}

function vote(id, userVote) {
  if (id && userVote) {
    Quote.findOne({id: id}, function(err, quote) {
      if (err) throw err;
      if (userVote == "down") {
        quote.downs++;
      } else {
        quote.ups++;
      }
      quote.save(function(err) { if (err) throw err; });
    });
  }
}

function sum(field, cb) {
  Quote.aggregate(
    { $group: { _id: null, total: { $sum: "$" + field }} },
    function(err, res) {
      if (err) throw err;
      cb(res);
    }
  );
}

function sumBoth(cb) {
  sum("ups", function(ups) {
    sum("downs", function(downs) {
      cb({ups: ups, downs: downs});
    });
  });
}

module.exports = {
  getQuote: getQuote,
  sumBoth: sumBoth,
  vote: vote
};
