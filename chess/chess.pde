import java.util.HashSet;
import javafx.util.Pair;
import java.util.concurrent.TimeUnit;

Board b;
float s; //size of a block on the board
StopWatchTimer timerPlayer, timerOpponent;
boolean isGameDone;
boolean playerWon;
boolean isPawnPromotionAvailable;
void setup() {
  size(800, 640);
  rectMode(CENTER);
  s = 80;
  b = new Board(s);
  timerPlayer = new StopWatchTimer(s * 8 + s / 2, s * 4 + s / 2);
  timerOpponent = new StopWatchTimer(s * 8 + s / 2, s * 3 + s / 2);
  timerPlayer.start();
  timerOpponent.start();
  if (!b.isPlayerTurn) {
    timerPlayer.stop();
  } else {
    timerOpponent.stop();
  }
  isGameDone = false;
  isPawnPromotionAvailable = false;
}

void draw() {
  if (isGameDone) {
    try {
      Thread.sleep(3000);
    }
    catch (InterruptedException e) {
    }
    System.exit(0);
  }
  if (isPawnPromotionAvailable) {
    showPromotionLog();
    return;
  }
  background(200);
  b.display();
  timerPlayer.display();
  timerOpponent.display();
  if (timerPlayer.getMinute() == 0 && timerPlayer.getSecond() == 0) {
    timerPlayer.stop();
    background(255);
    fill(255, 30, 0);
    textSize(32);
    text("Oponent wins!", 50, height / 2);
    isGameDone = true;
    playerWon = false;
  }
  if (timerOpponent.getMinute() == 0 && timerOpponent.getSecond() == 0) {
    timerOpponent.stop();
    background(255);
    fill(255, 30, 0);
    textSize(32);
    text("Player wins!", 50, height / 2);
    isGameDone = true;
    playerWon = true;
  }
}

void mousePressed() {
  if (!isPawnPromotionAvailable) {
    //select a piece
    for (int i = 0; i < b.numberOfPieces; ++i) {
      if  (b.pieces[i].isSelected()) {
        if (b.pieces[i].move(mouseX, mouseY)) {
          b.changeTurn();
          if (b.isPromotionAvailable()) {
            isPawnPromotionAvailable = true;
          }
          if (b.isPlayerTurn) {
            timerPlayer.restart();
            timerOpponent.stop();
          } else {
            timerPlayer.stop();
            timerOpponent.restart();
          }
        }
        b.pieces[i].deselect();
        b.deselect();
        b.take(b.pieces[i]);
        break;
      } else if (b.pieces[i].colides(mouseX, mouseY) && !b.hasPieceSelected) {
        if ((b.isPlayerTurn && b.isPlayerWhite == b.pieces[i].isPieceWhite) || 
          (!b.isPlayerTurn && b.isPlayerWhite != b.pieces[i].isPieceWhite)) {
          b.pieces[i].select(b.getBoardState(), b.isPlayerWhite);
          b.select(b.pieces[i]);
          break;
        }
      }
    }
  }
}

void keyPressed() {
  if (keyCode == 49) {
    b.promoteToBishop();
    isPawnPromotionAvailable = false;
  } else if (keyCode == 50) {
    b.promoteToBKnight();
    isPawnPromotionAvailable = false;
  } else if (keyCode == 51) {
    b.promoteToRook();
    isPawnPromotionAvailable = false;
  } else if (keyCode == 52) {
    b.promoteToQueen();
    isPawnPromotionAvailable = false;
  }
}

void showPromotionLog() {
  background(255);
  fill(0);
  textSize(32);
  text("Pick a piece:", 100, 50);
  text("1. Bishop", 100, 100);
  text("2. Knight", 100, 150);
  text("3. Rook", 100, 200);
  text("4. Queen", 100, 250);
}
