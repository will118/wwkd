var apn = require('apn');
var User = require('./user.js');
var library = require('./library.js');

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
  quote.save(function(err) { if (err) throw err; });
  return note;
}

function pushQuoteToOne(quote, token) {
  console.log('Sending quote:', quote, '\nto token:', token);
  var device = new apn.Device(token);
  var note = noteForQuote(quote, 1);
  apnConnection.pushNotification(note, device);
}

var startHour = 9;
var endHour = 21;
var hourCount = 0;

function filterSubscribed(user) {
  var currentHour = new Date().getHours();
  var localHours = currentHour + user.offset;
  var inWindow = (startHour <= localHours) && (localHours <= endHour);
  var wantsUpdate = (hourCount % user.frequency) === 0;

  if (user.subscribed && inWindow && wantsUpdate) {
    return true;
  } else {
    return false;
  }
}

function startScheduler() {
  setInterval(function() {
    library.getQuote(function(quote) {
      User.find(function(err, users) {
        if (err) console.error('Error getting all users');
        var note = noteForQuote(quote, users.length);
        console.log('Sending quote:', quote);

        users
          .filter(filterSubscribed)
          .forEach(function(user) {
            var token = user.token;
            if (token) {
              console.log('to user:', token);
              var device = new apn.Device(token);
              apnConnection.pushNotification(note, device);
            }
          });

        hourCount++;
      });
    });
  }, 1000 * 60 * 60);
}

module.exports = {
  pushQuoteToOne: pushQuoteToOne,
  startScheduler: startScheduler
};

