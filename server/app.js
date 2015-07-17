var express = require('express');
var bodyParser = require('body-parser');
var User = require('./user.js');
var library = require('./library.js');
var push = require('./push.js');

var app = express();

app.use(bodyParser.json());

app.use('/blessing', function (req, res) {
  console.log('Blessing requested:', req.body)
  if (req.body && req.body.token) {
    var sleepTime = 10 * 1000;
    setTimeout(function() {
      library.getQuote(function(quote) { push.pushQuoteToOne(quote, req.body.token) });
    }, sleepTime);
  } else {
    res.status(200).send({ error: 'exists' });
  }
})

app.use('/register', function (req, res) {
  console.log(req.body)
  if (req.body && req.body.token) {
    User.count({'token': req.body.token}, function(err, count) {
      if (err) throw err;

      if (count == 0) {
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
})

app.listen(3000);

