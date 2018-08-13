class King extends Piece {
  int[] nextX = {-1, 0, 1, 0, -1, 1, -1, 1};
  int[] nextY = {0, 1, 0, -1, -1, 1, 1, -1};
  King(int x, int y, float boardS, boolean isWhite) {
    super(x, y, boardS, isWhite);
    if (isWhite) {
      img = loadImage("white_king.png");
    } else {
      img = loadImage("black_king.png");
    }
    value = 1000000;
  }
  HashSet<Pair<Integer, Integer>> getAvailablePositions(int[][] boardState, boolean isPlayerWhite) {
    HashSet<Pair<Integer, Integer>> avPos = new HashSet<Pair<Integer, Integer>>();
    int newX;
    int newY;
    for (int i = 0; i < 8; ++i) {
      newX = posX + nextX[i];
      newY = posY + nextY[i];
      if (newX >= 0 && newX < 8 && newY < 8 && newY >= 0) {
        //piece is still inside the board
        if (boardState[newX][newY] == 0) {
          //empty position
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        } else if (boardState[newX][newY] < 0 && isPlayerWhite && this.isPieceWhite) {
          //white piece over black piece
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        } else if (boardState[newX][newY] > 0 && !isPlayerWhite && this.isPieceWhite) {
          //white piece over black piece from the oponent
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        } else if (boardState[newX][newY] > 0 && isPlayerWhite && !this.isPieceWhite) {
          //black piece over white from oponent
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        } else if (boardState[newX][newY] < 0 && !isPlayerWhite && !this.isPieceWhite) {
          //black piece over white
          avPos.add(new Pair<Integer, Integer>(newX, newY));
        }
      }
    }
    return avPos;
  }
}
