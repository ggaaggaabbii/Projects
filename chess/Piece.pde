abstract class Piece {
  int posX;
  int posY;
  int value;
  float boardSize;
  boolean selected = false;
  boolean isPieceWhite;
  boolean wasMoved;
  PImage img;
  HashSet<Pair<Integer, Integer>> availablePositions;

  Piece(int x, int y, float boardS, boolean isWhite) {
    posX = x;
    posY = y;
    boardSize = boardS;
    isPieceWhite = isWhite;
    availablePositions = new HashSet<Pair<Integer, Integer>>();
    wasMoved = false;
  }

  void display() {
    float boardX = posX * boardSize + boardSize / 2;
    float boardY = posY * boardSize + boardSize / 2;
    float drawSize;
    if (this.colides(mouseX, mouseY)) {
      drawSize = boardSize + 5;
    } else {
      drawSize = boardSize - 15;
    }
    imageMode(CENTER);
    if (selected) {
      drawSize = boardSize + 5;
      image(img, mouseX, mouseY, drawSize, drawSize);
    } else {
      image(img, boardX, boardY, drawSize, drawSize);
    }
  }

  boolean colides(float x, float y) {
    float boardX = posX * boardSize + boardSize / 2;
    float boardY = posY * boardSize + boardSize / 2;
    if (y > boardY - boardSize / 2 && y < boardY + boardSize / 2&&
      x > boardX - boardSize / 2 && x < boardX + boardSize / 2) {
      return true;
    }
    return false;
  }

  void select(int[][] boardState, boolean isPlayerWhite) {
    selected = true;
    availablePositions = getAvailablePositions(boardState, isPlayerWhite);
  }

  void deselect() {
    selected = false;
  }
  boolean isSelected() {
    return selected;
  }
  boolean move(float x, float y) {
    int newX = (int)(x / boardSize);
    int newY = (int)(y / boardSize);
    if (availablePositions.contains(new Pair<Integer, Integer>(newX, newY))) {
      posX = newX;
      posY = newY;
      wasMoved = true;
      return true;
    }
    return false;
  }
  abstract HashSet<Pair<Integer, Integer>> getAvailablePositions(int[][] boardState, boolean isPlayerWhite);
  
  boolean canTake(int[][] boardState, int newX, int newY, boolean isPlayerWhite) {
    if (boardState[newX][newY] < 0 && isPlayerWhite && this.isPieceWhite) {
          //white piece over black piece
          return true;
        } else if (boardState[newX][newY] > 0 && !isPlayerWhite && this.isPieceWhite) {
          //white piece over black piece from the oponent
          return true;
        } else if (boardState[newX][newY] > 0 && isPlayerWhite && !this.isPieceWhite) {
          //black piece over white from oponent
          return true;
        } else if (boardState[newX][newY] < 0 && !isPlayerWhite && !this.isPieceWhite) {
          //black piece over white
          return true;
        }
    return false;
  }
}
