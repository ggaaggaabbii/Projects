class Rook extends Piece {
  int[] nextX = {-1, 0, 1, 0};
  int[] nextY = {0, 1, 0, -1};
  Rook(int x, int y, float boardS, boolean isWhite) {
    super(x, y, boardS, isWhite);
    if (isWhite) {
      img = loadImage("white_rook.png");
    } else {
      img = loadImage("black_rook.png");
    }
    value = 5;
  }
  HashSet<Pair<Integer, Integer>> getAvailablePositions(int[][] boardState, boolean isPlayerWhite) {
    HashSet<Pair<Integer, Integer>> avPos = new HashSet<Pair<Integer, Integer>>();
    for (int i = 0; i < 4; ++i) {
      int newX = posX + nextX[i];
      int newY = posY + nextY[i];
      while (newX >= 0 && newY >= 0 && newX < 8 && newY < 8) {
        //we are still inside the board
        if (boardState[newX][newY] == 0) {
          //empty position
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        } else if (canTake(boardState, newX, newY, isPlayerWhite)) {
          avPos.add(new Pair<Integer, Integer>(newX, newY));
          break;
        } else {
          //same color piece
          break;
        }
        newX += nextX[i];
        newY += nextY[i];
      }
    }
    return avPos;
  }
}
