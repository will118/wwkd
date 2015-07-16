'use strict';

var fs = require('fs');

var processed = JSON.parse(fs.readFileSync('quotes.json', 'utf-8'));

var results = []

var id = 1

processed.forEach(function(sourceData) {
  var source = sourceData["source"]
  var xs = sourceData["body"]

  xs.forEach(function(x) {
    if (x.startsWith("http")) {
      //
    } else {
      results.push({id: id++, source: source, body: x})
    }
  })
})

fs.writeFileSync('quotes_library.json', JSON.stringify(results));
