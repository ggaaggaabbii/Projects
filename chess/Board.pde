class Board {
  int size;
  float sizeOfBlock;
  //variables used for drawing the background board
  float initialX;
  float initialY;
  color C1;
  color C2;
  int numberOfPieces;
  boolean hasPieceSelected;
  boolean isPlayerWhite;
  boolean isPlayerTurn;
  Piece[] pieces;
  HashSet<Pair<Integer, Integer>> availablePositions;
  LinkedList<Piece[]> historyOfMoves;
  King checkedKing;
  //will be used to check the neighbours of the chekced king to ensure the other king is not the one causing the check
  int[] nextX = {-1, 0, 1, 0, -1, 1, -1, 1};
  int[] nextY = {0, 1, 0, -1, -1, 1, 1, -1};

  Board(float s) {
    hasPieceSelected = false;
    numberOfPieces = 32;
    sizeOfBlock = s;
    initialX = s / 2;
    initialY = s / 2;
    size = 8;
    C1 = color(255);
    C2 = color(100);
    if (random(100) < 50) {
      isPlayerWhite = false;
      isPlayerTurn = false;
    } else {
      isPlayerWhite = true;
      isPlayerTurn = true;
    }

    pieces = new Piece[32];
    availablePositions = new HashSet<Pair<Integer, Integer>>();
    historyOfMoves = new LinkedList<Piece[]>();

    setupPawns();
    setupKnights();
    setupRooks();
    setupKingsAndQueens();
    setupBishops();
  }

  void display() {
    //display the background board
    float currentX = initialX;
    float currentY = initialY;
    float boardX;
    float boardY;
    boolean currentCol = true;
    int[][] board = this.getBoardState();
    for (int i = 0; i < size; ++i) {
      currentX = initialX;
      for (int j = 0; j < size; ++j) {
        if (currentCol) {
          fill(C1);
        } else {
          fill(C2);
        }
        noStroke();
        rect(currentX, currentY, sizeOfBlock, sizeOfBlock);
        currentX += sizeOfBlock;
        currentCol = !currentCol;
      }
      currentY += sizeOfBlock;
      currentCol = !currentCol;
    }
    //display available positions
    if (isCheck()) {
      availablePositions.add(new Pair<Integer, Integer>(checkedKing.posX, checkedKing.posY));
    } else {
      checkedKing = null;
    }
    for (Pair<Integer, Integer> p : availablePositions) {
      boardX = p.getKey() * sizeOfBlock + sizeOfBlock / 2;
      boardY = p.getValue() * sizeOfBlock + sizeOfBlock / 2;
      if (board[p.getKey()][p.getValue()] == 0) {
        fill(255, 255, 0, 50);
      } else {
        fill(255, 0, 0, 50);
      }
      rect(boardX, boardY, sizeOfBlock, sizeOfBlock);
    }
    //display every piece
    for (int i = 0; i < numberOfPieces; ++i) {
      pieces[i].display();
    }
  }
  boolean changeTurn() {
    King lastChecked = checkedKing;
    boolean isCheckResult = isCheck();
    if (isCheckResult && lastChecked == checkedKing) {
      undo();
      return false;
    } else if (isCheckResult && (isPlayerTurn ^ isPlayerWhite ^ checkedKing.isPieceWhite)) {
      undo();
      return false;
    } else if (isCheckResult && lastChecked != null) {
      //counter check
      undo();
      return false;
    } else if (isCheckResult) {
      for (int i = 0; i < 8; ++i) {
        Piece p = getPieceFromPosition(checkedKing.posX + nextX[i], checkedKing.posY + nextY[i]);
        if (p!=null) {
        }
        if (p instanceof King) {
          //kings came together
          undo(); 
          return false;
        }
      }
    }
    isPlayerTurn = !isPlayerTurn; 
    return true;
  }
  void deselect() {
    hasPieceSelected = false; 
    availablePositions.clear();
  }
  void select(Piece p) {
    hasPieceSelected = true; 
    availablePositions = p.getAvailablePositions(this.getBoardState(), isPlayerWhite);
  }
  void setupKnights() {
    //initialize the knights
    pieces[16] = new Knight(1, 7, sizeOfBlock, isPlayerWhite); 
    pieces[17] = new Knight(1, 0, sizeOfBlock, !isPlayerWhite); 
    pieces[18] = new Knight(6, 7, sizeOfBlock, isPlayerWhite); 
    pieces[19] = new Knight(6, 0, sizeOfBlock, !isPlayerWhite);
  }
  void setupRooks() {
    //initialize the rooks
    pieces[20] = new Rook(0, 7, sizeOfBlock, isPlayerWhite); 
    pieces[21] = new Rook(0, 0, sizeOfBlock, !isPlayerWhite); 
    pieces[22] = new Rook(7, 7, sizeOfBlock, isPlayerWhite); 
    pieces[23] = new Rook(7, 0, sizeOfBlock, !isPlayerWhite);
  }
  void setupKingsAndQueens() {
    //initialize the kings
    if (isPlayerWhite) {
      pieces[24] = new King(4, 7, sizeOfBlock, isPlayerWhite); 
      pieces[25] = new King(4, 0, sizeOfBlock, !isPlayerWhite); 
      pieces[26] = new Queen(3, 7, sizeOfBlock, isPlayerWhite); 
      pieces[27] = new Queen(3, 0, sizeOfBlock, !isPlayerWhite);
    } else {
      pieces[24] = new King(3, 7, sizeOfBlock, isPlayerWhite); 
      pieces[25] = new King(3, 0, sizeOfBlock, !isPlayerWhite); 
      pieces[26] = new Queen(4, 7, sizeOfBlock, isPlayerWhite); 
      pieces[27] = new Queen(4, 0, sizeOfBlock, !isPlayerWhite);
    }
  }
  void setupBishops() {
    pieces[28] = new Bishop(2, 7, sizeOfBlock, isPlayerWhite); 
    pieces[29] = new Bishop(5, 7, sizeOfBlock, isPlayerWhite); 
    pieces[30] = new Bishop(2, 0, sizeOfBlock, !isPlayerWhite); 
    pieces[31] = new Bishop(5, 0, sizeOfBlock, !isPlayerWhite);
  }
  void setupPawns() {
    //initialize the pawns
    for (int i = 0; i < 8; ++i) {
      pieces[i] = new Pawn(i, 6, sizeOfBlock, isPlayerWhite); 
      pieces[i + 8] = new Pawn(i, 1, sizeOfBlock, !isPlayerWhite);
    }
  }

  int[][] getBoardState() {
    int[][] board = new int[8][8]; 
    for (int i = 0; i < numberOfPieces; ++i) {
      if ((isPlayerWhite && pieces[i].isPieceWhite) || (!isPlayerWhite && !pieces[i].isPieceWhite)) {
        board[pieces[i].posX][pieces[i].posY] = pieces[i].value;
      } else {
        board[pieces[i].posX][pieces[i].posY] = -pieces[i].value;
      }
    }
    return board;
  }
  void take(Piece p) {
    for (int i = 0; i < numberOfPieces; ++i) {
      if (pieces[i] != p && pieces[i].posX == p.posX && pieces[i].posY == p.posY) {
        pieces[i] = pieces[numberOfPieces - 1]; 
        --numberOfPieces;
      }
    }
  }
  void promoteToBishop() {
    int i = getPositionOfPromotablePawn(); 
    //delete the pawn
    Piece aux = pieces[i]; 
    pieces[i] = pieces[numberOfPieces - 1]; 
    //add a new bishop
    pieces[numberOfPieces - 1] = new Bishop(
      aux.posX, 
      aux.posY, 
      aux.boardSize, 
      aux.isPieceWhite
      );
  }
  void promoteToBKnight() {
    int i = getPositionOfPromotablePawn(); 
    //delete the pawn
    Piece aux = pieces[i]; 
    pieces[i] = pieces[numberOfPieces - 1]; 
    //add a new bishop
    pieces[numberOfPieces - 1] = new Knight(
      aux.posX, 
      aux.posY, 
      aux.boardSize, 
      aux.isPieceWhite
      );
  }
  void promoteToRook() {
    int i = getPositionOfPromotablePawn(); 
    //delete the pawn
    Piece aux = pieces[i]; 
    pieces[i] = pieces[numberOfPieces - 1]; 
    //add a new bishop
    pieces[numberOfPieces - 1] = new Rook(
      aux.posX, 
      aux.posY, 
      aux.boardSize, 
      aux.isPieceWhite
      );
  }
  void promoteToQueen() {
    int i = getPositionOfPromotablePawn(); 
    //delete the pawn
    Piece aux = pieces[i]; 
    pieces[i] = pieces[numberOfPieces - 1]; 
    //add a new bishop
    pieces[numberOfPieces - 1] = new Queen(
      aux.posX, 
      aux.posY, 
      aux.boardSize, 
      aux.isPieceWhite
      );
  }
  boolean isPromotionAvailable() {
    int i = getPositionOfPromotablePawn(); 
    if (i != -1) {
      return true;
    }
    return false;
  }
  int getPositionOfPromotablePawn() {
    for (int i = 0; i < numberOfPieces; ++i) {
      if (pieces[i] instanceof Pawn) {
        if (pieces[i].posY == 0 || pieces[i].posY == 7) {
          return i;
        }
      }
    }
    return -1;
  }
  HashSet<Pair<Integer, Pair<Integer, Boolean>>> getAllAvailableAttackMoves() {
    HashSet<Pair<Integer, Pair<Integer, Boolean>>> avPos = new HashSet<Pair<Integer, Pair<Integer, Boolean>>>(); 
    for (int i = 0; i < numberOfPieces; ++i) {
      for (Pair<Integer, Integer > p : pieces[i].getAvailablePositions(getBoardState(), isPlayerWhite)) {
        Pair<Integer, Boolean> a = new Pair<Integer, Boolean>(p.getValue(), pieces[i].isPieceWhite); 
        avPos.add(new Pair<Integer, Pair<Integer, Boolean>>(p.getKey(), a));
      }
      if (pieces[i] instanceof Pawn) {
        //pawns attack diagonally
        Pawn p = (Pawn)pieces[i]; 
        Pair<Integer, Boolean> a = new Pair<Integer, Boolean>(p.posY + p.yDirection, pieces[i].isPieceWhite); 
        avPos.add(new Pair<Integer, Pair<Integer, Boolean>>(p.posX + 1, a)); 
        a = new Pair<Integer, Boolean>(p.posY + p.yDirection, pieces[i].isPieceWhite); 
        avPos.add(new Pair<Integer, Pair<Integer, Boolean>>(p.posX - 1, a));
      }
    }
    return avPos;
  }
  boolean isCheck() {
    HashSet<Pair<Integer, Pair<Integer, Boolean>>> avPos = getAllAvailableAttackMoves(); 
    for (int i = 0; i < numberOfPieces; ++i) {
      Pair<Integer, Boolean> a = new Pair<Integer, Boolean>(pieces[i].posY, !pieces[i].isPieceWhite); 
      if (avPos.contains(new Pair<Integer, Pair<Integer, Boolean>>(pieces[i].posX, a))) {
        if (pieces[i] instanceof King) {
          checkedKing = (King)pieces[i]; 
          return true;
        }
      }
    }
    return false;
  }
  boolean undo() {
    if (historyOfMoves.size() > 0) {
      pieces = historyOfMoves.pollLast(); 
      numberOfPieces = max(numberOfPieces, pieces.length); 
      return true;
    }
    return false;
  }
  void storeState() {
    Piece[] currentState = new Piece[numberOfPieces]; 
    for (int i = 0; i < numberOfPieces; ++i) {
      currentState[i] = pieces[i].clone();
    }
    historyOfMoves.add(currentState); 
    if (historyOfMoves.size() > 10) {
      //keep only the last 10 moves
      historyOfMoves.pollFirst();
    }
  }
  Piece getPieceFromPosition(int x, int y) {
    for (int i = 0; i < numberOfPieces; ++i) {
      if (pieces[i].posX == x && pieces[i].posY == y) {
        return pieces[i];
      }
    }
    return null;
  }
}
