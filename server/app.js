var express = require('express');
var bodyParser = require('body-parser');
var User = require('./user.js');
var library = require('./library.js');
var push = require('./push.js');

var app = express();

app.use(bodyParser.json());

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

app.get('/prophetic', function (req, res) {
  sumBoth(function(sums) {
    console.log(sums);
    res.send({score: 0.77});
  });
});

app.use('/vote', function (req, res) {
  console.log('Vote:', req.body);
  if (req.body && req.body.id && req.body.vote) {
    library.vote(req.body.id, req.body.vote);
    res.status(200).send({ error: 'exists' });
  } else {
    res.status(200).send({ error: 'No id or vote provided' });
  }
});

app.use('/blessing', function (req, res) {
  console.log('Blessing requested:', req.body);
  if (req.body && req.body.token) {
    var sleepTime = 10 * 1000;
    setTimeout(function() {
      library.getQuote(function(quote) { push.pushQuoteToOne(quote, req.body.token); });
    }, sleepTime);
    res.status(200).send({ status: 'queued', duration: sleepTime });
  } else {
    res.status(200).send({ error: 'exists' });
  }
});

app.use('/register', function (req, res) {
  console.log(req.body);
  if (req.body && req.body.token) {
    User.count({'token': req.body.token}, function(err, count) {
      if (err) throw err;

      if (count === 0) {
        var user = new User();
        user.token = req.body.token;
        user.save(function(err) {
          if (err) throw err;
          console.log('Saved new user');
          res.sendStatus(200);
        });
      } else {
        res.status(200).send({ error: 'exists' });
      }
    });
  } else {
    res.status(200).send({ error: 'exists' });
  }
});

app.listen(3000);

