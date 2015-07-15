var apn = require('apn');

var options = { };

var apnConnection = new apn.Connection(options);

var token = '58473a559f4b3550a9b3ae0a29d6bb176be7fc4ecdfecfcc7542b18e678d3fc9'

var myDevice = new apn.Device(token);

var note = new apn.Notification();

note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
note.badge = 3;
note.sound = "ping.aiff";
note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
note.payload = {'messageFrom': 'Caroline'};

apnConnection.pushNotification(note, myDevice);


