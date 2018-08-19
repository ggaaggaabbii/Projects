let canvas;
let myMap;
const mappa = new Mappa('Leaflet');
let lat = undefined;
let lon = undefined;

const options = {
  lat: 0,
  lng: 0,
  zoom: 2,
  style: "http://{s}.tile.osm.org/{z}/{x}/{y}.png"
}
var socket;

function setup() {
  socket = io.connect('http://localhost:8080');
  socket.on('location', receiveLocation);
  canvas = createCanvas(600, 480);
  myMap = mappa.tileMap(options);
  myMap.overlay(canvas);
}

function receiveLocation(data) {
  console.log(data);
  let localData = JSON.parse(data);
  lat = localData.lat;
  lon = localData.lon;
  console.log(lat + " " + lon);
  console.log("received loc");

}

function draw() {
  clear();
  if (lat != undefined && lon != undefined) {
    const locationOnCanvas = myMap.latLngToPixel(lat, lon);
    fill(255, 0, 0);
    ellipse(locationOnCanvas.x, locationOnCanvas.y, 10, 10);
  }
}