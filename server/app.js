var express    = require('express')
var bodyParser = require('body-parser')
var User = require('./user.js');

var app = express()

app.use(bodyParser.json())

app.use('/register', function (req, res) {
  console.log(req.body)
  if (req.body && req.body.token) {
    var user = new User();
    user.token = req.body.token;
    user.save(function(err) {
      if (err) throw err;
      console.log('Saved new user');
      res.sendStatus(200);
    });
  }
})

app.listen(3000, function () { });
