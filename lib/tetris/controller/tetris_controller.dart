// lib/controllers/game_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/block.dart';

class TetrisController extends ChangeNotifier {
  static const int rowCount = 20;
  static const int colCount = 10;
  Block? nextBlock;

  late List<List<Color?>> grid;
  Block? currentBlock;
  int blockRow = 0;
  int blockCol = 3;

  bool isPlaying = false;
  Timer? gameTimer;

  TetrisController() {
    resetGrid();
  }

  void resetGrid() {
    grid = List.generate(rowCount, (_) => List.filled(colCount, null));
    notifyListeners();
  }

  void startGame() {
    isPlaying = true;
    nextBlock = getRandomBlock();
    spawnBlock();
    gameTimer =
        Timer.periodic(const Duration(milliseconds: 500), (_) => moveDown());
  }

  Block getRandomBlock() {
    final random = Random();
    return blocks[random.nextInt(blocks.length)];
  }

  void spawnBlock() {
    currentBlock = nextBlock;
    nextBlock = getRandomBlock();
    blockRow = 0;
    blockCol = 3;

    if (checkCollision(currentBlock!, blockRow, blockCol)) {
      gameOver();
    }
    notifyListeners();
  }

  void moveLeft() {
    if (!checkCollision(currentBlock!, blockRow, blockCol - 1)) {
      blockCol--;
      notifyListeners();
    }
  }

  void moveRight() {
    if (!checkCollision(currentBlock!, blockRow, blockCol + 1)) {
      blockCol++;
      notifyListeners();
    }
  }

  void moveDown() {
    if (!checkCollision(currentBlock!, blockRow + 1, blockCol)) {
      blockRow++;
    } else {
      fixBlock();
      clearLines();
      spawnBlock();
    }
    notifyListeners();
  }

  void rotate() {
    final rotatedShape = rotateMatrix(currentBlock!.shape);
    if (!checkCollision(Block(shape: rotatedShape, color: currentBlock!.color),
        blockRow, blockCol)) {
      currentBlock = Block(shape: rotatedShape, color: currentBlock!.color);
      notifyListeners();
    }
  }

  List<List<int>> rotateMatrix(List<List<int>> matrix) {
    final n = matrix.length;
    final m = matrix[0].length;
    List<List<int>> rotated = List.generate(m, (_) => List.filled(n, 0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        rotated[j][n - 1 - i] = matrix[i][j];
      }
    }
    return rotated;
  }

  bool checkCollision(Block block, int row, int col) {
    for (int i = 0; i < block.shape.length; i++) {
      for (int j = 0; j < block.shape[i].length; j++) {
        if (block.shape[i][j] == 1) {
          int x = row + i;
          int y = col + j;
          if (x >= rowCount ||
              y < 0 ||
              y >= colCount ||
              (x >= 0 && grid[x][y] != null)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void fixBlock() {
    for (int i = 0; i < currentBlock!.shape.length; i++) {
      for (int j = 0; j < currentBlock!.shape[i].length; j++) {
        if (currentBlock!.shape[i][j] == 1) {
          int x = blockRow + i;
          int y = blockCol + j;
          if (x >= 0 && y >= 0 && y < colCount) {
            grid[x][y] = currentBlock!.color;
          }
        }
      }
    }
  }

  void clearLines() {
    for (int i = rowCount - 1; i >= 0; i--) {
      if (grid[i].every((cell) => cell != null)) {
        grid.removeAt(i);
        grid.insert(0, List.filled(colCount, null));
      }
    }
  }

  void gameOver() {
    isPlaying = false;
    gameTimer?.cancel();
    notifyListeners();
  }
}
