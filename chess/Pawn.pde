class Pawn extends Piece {
  int yDirection;
  int[] nextX = {-1, 1};

  Pawn(int x, int y, float boardS, boolean isWhite) {
    super(x, y, boardS, isWhite);
    if (isWhite) {
      img = loadImage("white_pawn.png");
    } else {
      img = loadImage("black_pawn.png");
    }
    value = 1;
    wasMoved = false;
  }
  HashSet<Pair<Integer, Integer>> getAvailablePositions(int[][] boardState, boolean isPlayerWhite) {
    HashSet<Pair<Integer, Integer>> avPos = new HashSet<Pair<Integer, Integer>>();
    if ((isPieceWhite && isPlayerWhite) || (!isPlayerWhite && !isPieceWhite)) {
      yDirection = -1;
    } else {
      yDirection = 1;
    }

    if (boardState[posX][posY + yDirection] == 0) {
      int newX = posX;
      int newY = posY + yDirection;
      if (!canTake(boardState, newX, newY, isPlayerWhite)) {
        avPos.add(new Pair<Integer, Integer>(newX, newY));
      }
      if (!wasMoved) {
        newY += yDirection;
        if (!canTake(boardState, newX, newY, isPlayerWhite)) {
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        }
      }
    }
    for (int i = 0; i < 2; ++i) {
      int newX = posX + nextX[i];
      int newY = posY + yDirection;
      if (newX >= 0 && newX < 8 && newY < 8 && newY >= 0) {
        //piece is still inside the board
        if (canTake(boardState, newX, newY, isPlayerWhite)) {
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        }
      }
    }
    return avPos;
  }
  Pawn clone() {
    Pawn p = new Pawn(posX, posY, boardSize, isPieceWhite);
    p.wasMoved = wasMoved;
    return p;
  }
}
