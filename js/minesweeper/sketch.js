var vscale = 24,
  MAXN = 22;
var matrix = new Array(MAXN);
var viz = new Array(MAXN);
var viz2 = new Array(MAXN);
var sunet, c = 51,
  bombs, nrbombs;
var dl = [-1, 0, 1, 1, 1, 0, -1, -1],
  dc = [-1, -1, -1, 0, 1, 1, 1, 0];
var imagini = new Array(9),
  steag, ex;
var mort = false;
var scor, win, timp;
var t;

function preload() {
  ex = loadImage('images/imgexp.jpg');
  steag = loadImage('images/imgsteag.jpg');
  imagini[0] = loadImage('images/img0.png');
  imagini[1] = loadImage('images/img1.png');
  imagini[2] = loadImage('images/img2.png');
  imagini[3] = loadImage("images/img3.png");
  imagini[4] = loadImage("images/img4.png");
  imagini[5] = loadImage("images/img5.png");
  imagini[6] = loadImage("images/img6.png");
  imagini[7] = loadImage("images/img7.png");
  imagini[8] = loadImage("images/img8.png");
  sunet = loadSound("Bomb_Sound.mp3");
  var reset = select('#rrButton');
  reset.mousePressed(setup);
  scor = createElement('h1', " ");
  scor.position(500, 50);
  win = createElement('h1', " ");
  win.position(550, 250);
  timp = createElement('h1', " ");
  timp.position(600, 100);
  setInterval(timeIT, 1000);
}

function setup() {
  canvas = createCanvas(481, 481);
  canvas.parent('container');
  timp.html("00:00");
  bombs = 0;
  var i;
  t = 0;
  mort = false;
  for (i = 0; i < MAXN; i++) {
    matrix[i] = new Array(MAXN);
    viz[i] = new Array(MAXN);
    viz2[i] = new Array(MAXN);
    for (var j = 0; j < MAXN; j++) {
      viz[i][j] = false;
      matrix[i][j] = false;
      viz2[i][j] = false;
      if (i !== 0 && j !== 0 && i !== MAXN - 1 && j !== MAXN - 1 && bombs < 65 && random(1) < 0.2) {
        matrix[i][j] = true;
        ++bombs;
      }
    }
  }
  nrbombs = bombs;
  background(c);
  for (var x = 0; x < height / vscale; x++) {
    for (var y = 0; y < width / vscale; y++) {
      fill(165);
      noStroke();
      rect(1 + x * vscale, 1 + y * vscale, vscale - 1, vscale - 1);
    }
  }
  scor.html("Bombe ramase: " + bombs);
  win.html(" ");
}

function draw() {}

function mousePressed() {
  if (!mort) {
    var x = (int)(1 + mouseX / vscale);
    if (mouseX % vscale === 0)
      --x;
    var y = (int)(1 + mouseY / vscale);
    if (mouseY % vscale === 0)
      --y;
    if (mouseButton == LEFT) {
      var vecini = 0;
      if (matrix[x][y] === true)
        detonare();
      else {
        vecini = getvecini(x, y);
        if (viz2[x][y]) {
          ++bombs;
          viz2[x][y] = false;
        }
        image(imagini[vecini], (x - 1) * vscale + 1, (y - 1) * vscale + 1, vscale - 1, vscale - 1);
        viz[x][y] = true;
        if (x < MAXN - 1 && x > 0 && y < MAXN - 1 && y > 0 && vecini === 0) {
          viz[x][y] = true;
          umple(x, y);
        }
      }
    } else
    if (mouseButton == CENTER && !viz[x][y]) {
      if (!viz2[x][y]) {
        viz2[x][y] = true;
        image(steag, (x - 1) * vscale + 1, (y - 1) * vscale + 1, vscale - 1, vscale - 1);
        --bombs;
      } else {
        rect(1 + (x - 1) * vscale, 1 + (y - 1) * vscale, vscale - 1, vscale - 1);
        viz2[x][y] = false;
        ++bombs;
      }
    }
    scor.html("Bombe ramase: " + bombs);
    if (bombs === 0 && validare()) {
      win.html("WIN!");
      mort = true;
    }
  }
}

function detonare() {
  sunet.play();
  mort = true;
  for (var i = 0; i < height / vscale; i++) {
    for (var j = 0; j < width / vscale; j++) {
      if (matrix[i + 1][j + 1] === true) {
        image(ex, i * vscale + 1, j * vscale + 1, vscale - 1, vscale - 1);
      }
    }
  }
  win.html("Game over!");
}

function getvecini(x, y) {
  var vecini = 0;
  for (var i = 0; i < 8; i++) {
    var ln = (int)(x + dl[i]);
    var cn = (int)(y + dc[i]);
    if (cn > 0 && cn < MAXN - 1 && ln > 0 && ln < MAXN - 1 && matrix[ln][cn] === true) {
      ++vecini;
    }
  }
  return vecini;
}

function umple(x, y) {
  viz[x][y] = true;
  for (var i = 0; i < 8; i++) {
    var ln = x + dl[i];
    var cn = y + dc[i];
    v = getvecini(ln, cn);
    image(imagini[v], (ln - 1) * vscale + 1, (cn - 1) * vscale + 1, vscale - 1, vscale - 1);
    if (ln > 0 && ln < MAXN - 1 && cn > 0 && cn < MAXN - 1 && v === 0 && !viz[ln][cn]) {
      viz[ln][cn] = true;
      umple(ln, cn);
    }
    if (viz2[ln][cn]) {
      ++bombs;
      viz2[ln][cn] = false;
    }
    viz[ln][cn] = true;

  }
}

function validare() {
  var vizite = 0;
  for (var i = 1; i < MAXN - 1; ++i)
    for (var j = 1; j < MAXN - 1; ++j)
      if (viz[i][j])
        ++vizite;
  print(vizite);
  if (vizite === 400 - nrbombs)
    return true;
  return false;
}

function timeIT() {
  if (!mort) {
    ++t;
    if (t / 60 < 10)
      if (t % 60 < 10)
        timp.html('0' + (int)(t / 60) + ':0' + t % 60)
    else
      timp.html('0' + (int)(t / 60) + ':' + t % 60);
    else
    if (t % 60 < 10)
      timp.html((int)(t / 60) + ':0' + t % 60)
    else
      timp.html((int)(t / 60) + ':' + t % 60);
  }
}
