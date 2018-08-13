import java.util.HashSet;
import javafx.util.Pair;

Board b;
float s; //size of a block on the board
StopWatchTimer timerPlayer, timerOpponent;
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
}

void draw() {
  background(200);
  b.display();
  timerPlayer.display();
  timerOpponent.display();
  if (timerPlayer.getMinute() == 0 && timerPlayer.getSecond() == 0) {
    timerPlayer.stop();
  }
  if (timerOpponent.getMinute() == 0 && timerOpponent.getSecond() == 0) {
    timerOpponent.stop();
  }
}

void mousePressed() {
  //select a piece
  for (int i = 0; i < b.numberOfPieces; ++i) {
    if  (b.pieces[i].isSelected()) {
      if (b.pieces[i].move(mouseX, mouseY)) {
        b.changeTurn();
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

void keyPressed() {
}
