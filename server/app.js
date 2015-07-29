var express = require('express');
var bodyParser = require('body-parser');
var User = require('./user.js');
var library = require('./library.js');
var push = require('./push.js');
var nib = require('nib');
var stylus = require('stylus');
var morgan = require('morgan');

var app = express();

app.use(bodyParser.json());

push.startScheduler();

app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(morgan('dev'));

app.use(stylus.middleware(
  { src: __dirname + '/public',
    compile: function(str, path) {
      return stylus(str)
        .set('filename', path)
        .use(nib());
    }
  }
));

app.use(express.static(__dirname + '/public'));

app.get('/', function (req, res) {

  library.getQuote(function(quote) {
    res.render('quote',
    { title : 'Quote',
      quote : quote.body }
    );
  });
});

app.get('/quote/:id', function (req, res) {
  var quoteId = req.params.id;
  if (quoteId) {
    library.findQuote(quoteId, function(quote) {
      res.render('quote',
      { title : 'Quote',
        quote : quote.body }
      );
    });
  }
});

app.get('/prophetic', function (req, res) {
  library.sumBoth(function(sums) {
    var total = sums.ups + sums.downs;
    var score = sums.ups / total;
    res.send({score: score});
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
    var min = 0;
    var max = 60;
    var seconds = Math.floor(Math.random() * (max - min + 1)) + min;
    var sleepTime = seconds * 1000;
    setTimeout(function() {
      library.getQuote(function(quote) { push.pushQuoteToOne(quote, req.body.token); });
    }, sleepTime);
    res.status(200).send({ status: 'queued', duration: sleepTime });
  } else {
    res.status(200).send({ error: 'exists' });
  }
});

app.use('/register', function (req, res) {
  console.log('Registering new token:', req.body);
  if (req.body && req.body.token) {
    User.count({'token': req.body.token}, function(err, count) {
      if (err) throw err;
      if (count === 0) {
        var user = new User();
        user.token = req.body.token;
        user.subscribed = false;
        user.offset = 1;
        user.frequency = 3;
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

app.use('/subscribe', function (req, res) {
  console.log('Updating subscription settings:', req.body);
  if (req.body && req.body.token && req.body.subscribed && req.body.frequency && req.body.offset) {
    User.findOne({'token': req.body.token}, function(err, user) {
      if (err) throw err;
      if (user) {
        user.subscribed = req.body.subscribed;
        user.offset = req.body.offset;
        user.frequency = req.body.frequency;
        user.save(function(err) {
          if (err) throw err;
          console.log('Updated subscription settings for user.');
          res.sendStatus(200);
        });
      } else {
        res.status(200).send({ error: 'could not find matching user.' });
      }
    });
  } else {
    res.status(200).send({ error: 'Invalid request payload.' });
  }
});


app.listen(3000);

