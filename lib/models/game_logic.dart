import 'dart:math';
import 'tile.dart';

enum Direction { up, down, left, right }

class GameLogic {
  static const int boardSize = 4;
  List<List<Tile>> board;
  int score = 0;
  int bestScore = 0;
  final Random random = Random();

  GameLogic()
      : board = List.generate(
          boardSize,
          (i) => List.generate(
            boardSize,
            (j) => Tile(value: 0, position: Position(i, j)),
          ),
        ) {
    // 在构造函数中直接初始化游戏
    initGame();
  }

  void initGame() {
    // 清空棋盘
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        board[i][j].value = 0;
        board[i][j].merged = false;
      }
    }
    score = 0;
    
    // 确保生成两个初始方块
    addRandomTile();
    addRandomTile();
  }

  void addRandomTile() {
    List<Position> emptyPositions = [];
    
    // 找出所有空位置
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j].value == 0) {
          emptyPositions.add(Position(i, j));
        }
      }
    }

    if (emptyPositions.isEmpty) return;

    // 随机选择一个空位置
    Position pos = emptyPositions[random.nextInt(emptyPositions.length)];
    // 90%概率生成2，10%概率生成4
    board[pos.row][pos.col].value = random.nextDouble() < 0.9 ? 2 : 4;
  }

  bool move(Direction direction) {
    bool moved = false;
    // 重置所有格子的合并状态
    for (var row in board) {
      for (var tile in row) {
        tile.merged = false;
      }
    }

    switch (direction) {
      case Direction.left:
        moved = moveLeft();
        break;
      case Direction.right:
        moved = moveRight();
        break;
      case Direction.up:
        moved = moveUp();
        break;
      case Direction.down:
        moved = moveDown();
        break;
    }

    if (moved) {
      addRandomTile();
    }

    return moved;
  }

  bool moveLeft() {
    bool moved = false;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 1; j < boardSize; j++) {
        if (board[i][j].value != 0) {
          int col = j;
          while (col > 0 && canMoveOrMerge(i, col, i, col - 1)) {
            if (board[i][col - 1].value == 0) {
              board[i][col - 1].value = board[i][col].value;
              board[i][col].value = 0;
              col--;
              moved = true;
            } else if (board[i][col - 1].value == board[i][col].value &&
                !board[i][col - 1].merged) {
              board[i][col - 1].value *= 2;
              board[i][col - 1].merged = true;
              board[i][col].value = 0;
              score += board[i][col - 1].value;
              bestScore = max(bestScore, score);
              moved = true;
              break;
            } else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  bool moveRight() {
    bool moved = false;
    for (int i = 0; i < boardSize; i++) {
      for (int j = boardSize - 2; j >= 0; j--) {
        if (board[i][j].value != 0) {
          int col = j;
          while (col < boardSize - 1 && canMoveOrMerge(i, col, i, col + 1)) {
            if (board[i][col + 1].value == 0) {
              board[i][col + 1].value = board[i][col].value;
              board[i][col].value = 0;
              col++;
              moved = true;
            } else if (board[i][col + 1].value == board[i][col].value &&
                !board[i][col + 1].merged) {
              board[i][col + 1].value *= 2;
              board[i][col + 1].merged = true;
              board[i][col].value = 0;
              score += board[i][col + 1].value;
              bestScore = max(bestScore, score);
              moved = true;
              break;
            } else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  bool moveUp() {
    bool moved = false;
    for (int j = 0; j < boardSize; j++) {
      for (int i = 1; i < boardSize; i++) {
        if (board[i][j].value != 0) {
          int row = i;
          while (row > 0 && canMoveOrMerge(row, j, row - 1, j)) {
            if (board[row - 1][j].value == 0) {
              board[row - 1][j].value = board[row][j].value;
              board[row][j].value = 0;
              row--;
              moved = true;
            } else if (board[row - 1][j].value == board[row][j].value &&
                !board[row - 1][j].merged) {
              board[row - 1][j].value *= 2;
              board[row - 1][j].merged = true;
              board[row][j].value = 0;
              score += board[row - 1][j].value;
              bestScore = max(bestScore, score);
              moved = true;
              break;
            } else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  bool moveDown() {
    bool moved = false;
    for (int j = 0; j < boardSize; j++) {
      for (int i = boardSize - 2; i >= 0; i--) {
        if (board[i][j].value != 0) {
          int row = i;
          while (row < boardSize - 1 && canMoveOrMerge(row, j, row + 1, j)) {
            if (board[row + 1][j].value == 0) {
              board[row + 1][j].value = board[row][j].value;
              board[row][j].value = 0;
              row++;
              moved = true;
            } else if (board[row + 1][j].value == board[row][j].value &&
                !board[row + 1][j].merged) {
              board[row + 1][j].value *= 2;
              board[row + 1][j].merged = true;
              board[row][j].value = 0;
              score += board[row + 1][j].value;
              bestScore = max(bestScore, score);
              moved = true;
              break;
            } else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  bool canMoveOrMerge(int fromRow, int fromCol, int toRow, int toCol) {
    return board[toRow][toCol].value == 0 ||
        (board[toRow][toCol].value == board[fromRow][fromCol].value &&
            !board[toRow][toCol].merged);
  }

  bool isGameOver() {
    // 检查是否还有空格
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j].value == 0) {
          return false;
        }
      }
    }

    // 检查是否还能合并
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (i < boardSize - 1 && board[i][j].value == board[i + 1][j].value) {
          return false;
        }
        if (j < boardSize - 1 && board[i][j].value == board[i][j + 1].value) {
          return false;
        }
      }
    }

    return true;
  }
}