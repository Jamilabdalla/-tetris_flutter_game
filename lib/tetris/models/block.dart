// lib/models/block.dart
import 'package:flutter/material.dart';

class Block {
  final List<List<int>> shape;
  final Color color;

  Block({required this.shape, required this.color});
}

// Formatos das peças do Tetris
final List<Block> blocks = [
  Block(
    shape: [
      [1, 1, 1, 1] // Linha
    ],
    color: Colors.cyan,
  ),
  Block(
    shape: [
      [1, 1],
      [1, 1], // Quadrado
    ],
    color: Colors.yellow,
  ),
  Block(
    shape: [
      [0, 1, 0],
      [1, 1, 1], // T
    ],
    color: Colors.purple,
  ),
  Block(
    shape: [
      [1, 0, 0],
      [1, 1, 1], // L
    ],
    color: Colors.orange,
  ),
  Block(
    shape: [
      [0, 0, 1],
      [1, 1, 1], // J
    ],
    color: Colors.blue,
  ),
  Block(
    shape: [
      [0, 1, 1],
      [1, 1, 0], // S
    ],
    color: Colors.green,
  ),
  Block(
    shape: [
      [1, 1, 0],
      [0, 1, 1], // Z
    ],
    color: Colors.red,
  ),
];
