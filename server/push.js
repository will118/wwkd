var apn = require('apn');
var User = require('./user.js');

var apnConnection = new apn.Connection({});

function noteForQuote(quote, recipientCount) {
  var note = new apn.Notification();
  note.expiry = Math.floor(Date.now() / 1000) + 3600;
  note.badge = 1;
  note.sound = "ping.aiff";
  note.alert = quote.body;
  note.category = "ACTIONABLE";
  note.payload = {
    'messageFrom': 'Yeezus',
    'quoteId': quote.id
  };

  if (recipientCount) {
    quote.shows = quote.shows + recipientCount;
  } else {
    quote.shows++;
  }
  quote.save(function(err) { if (err) throw err });
  return note;
}

function pushQuoteToOne(quote, token) {
  console.log('Sending quote:', quote, '\nto token:', token);
  var device = new apn.Device(token);
  var note = noteForQuote(quote, 1);
  apnConnection.pushNotification(note, device);
}

function pushQuoteToAll(quote) {
  getAllTokens(function(users) {
    var note = noteForQuote(quote, users.length);
    console.log('Sending quote:', quote);
    users.forEach(function(user) {
      var token = user.token;
      if (token) {
        var device = new apn.Device(token);
        apnConnection.pushNotification(note, device);
      }
    });
  });
}

function getAllTokens(cb) {
  User.find(function(err, users) {
    if (err) console.error('Error getting all users');
    cb(users);
  });
}

module.exports = {
  pushQuoteToAll: pushQuoteToAll,
  pushQuoteToOne: pushQuoteToOne
}
