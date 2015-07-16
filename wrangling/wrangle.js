'use strict';

var fs = require('fs');

var text = fs.readFileSync('quotes.txt', 'utf-8');

var sources = text.replace(/\r\n/g, '\n').split('________________');

var xs = sources.map(function(x) {
  let lines = x.split('\n').filter(function(y) { return y != ''; });

  let obj = {
    source: lines[0]
  }

  if (lines[1].includes('http')) {
    obj.url = lines[1]
    obj.body = lines.slice(2)
  } else {
    obj.body = lines.slice(1)
  }

  return obj;
})


fs.writeFileSync('quotes.json', JSON.stringify(xs, null, 4))
