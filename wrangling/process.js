'use strict';

var fs = require('fs');

var processed = JSON.parse(fs.readFileSync('quotes.json', 'utf-8'));

processed.forEach(function(x) {
  x.body = x.body.map(function(y) {
     return y.replace(/\d{1,2}:\d{2}/g, '').trim();
  });
})

fs.writeFileSync('quotes.json', JSON.stringify(processed, null, 4));
