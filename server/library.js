var Quote = require('./quote.js');
var utils = require('./utils.js');

function getQuote(cb) {
  findQuote(null, cb);
}

function findQuote(id, cb) {
  var quotes = id ? Quote.find({id: id}) : Quote.find();

  quotes
    .sort({shows: 'asc'})
    .exec(function(err, quotes) {
    if (err) throw err;
    if (quotes.length < 1) {
      console.log('No quotes in db, will attempt to load defaults and retry this function.');
      utils.loadDefaultIntoDb(function() { getQuote(cb); });
    } else {
      var min = Math.min.apply(Math, quotes.map(function(x){ return x.shows; }));
      var minValues = quotes.filter(function(x) {
        return x.shows === min;
      });
      minValues.sort(function(a, b) { return a.body.length - b.body.length; });
      cb(minValues[Math.floor(Math.random()*minValues.length)]);
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
      if (res[0] && res[0].total) {
        cb(res[0].total);
      }
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
  findQuote: findQuote,
  sumBoth: sumBoth,
  vote: vote
};
