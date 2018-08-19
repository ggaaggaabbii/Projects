var express = require('express');

var app = express();
var server = app.listen(8080);

app.use(express.static('public'));

var socket = require('socket.io');
var io = socket(server);

io.sockets.on('connection', newConnection);

function newConnection(socket) {
  console.log("new connection: " + socket.id);

  socket.on('location', sendLocationToClients);

  function sendLocationToClients(data) {
    socket.broadcast.emit('location', data);
    //io.sockets.emit('location', data);
    console.log(data);
  }
}