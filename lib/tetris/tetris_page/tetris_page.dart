import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/tetris/controller/tetris_controller.dart';
import 'package:tetris_app/tetris/widgets/control_button.dart';

class TetrisPage extends StatelessWidget {
  const TetrisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tetrisController = Provider.of<TetrisController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          !tetrisController.isPlaying ? 'Inicie o Jogo' : 'Tetris',
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Próxima peça
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.6),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: tetrisController.nextBlock != null
                          ? GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: 16,
                              itemBuilder: (context, index) {
                                int row = index ~/ 4;
                                int col = index % 4;
                                Color? color;
                                if (row < tetrisController.nextBlock!.shape.length &&
                                    col < tetrisController.nextBlock!.shape[row].length &&
                                    tetrisController.nextBlock!.shape[row][col] == 1) {
                                  color = tetrisController.nextBlock!.color;
                                }
                                return Container(
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: color ?? Colors.transparent,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            // Grid do jogo
            Expanded(
              child: InkWell(
                onTap: () {
                  if (tetrisController.isPlaying) {
                   tetrisController.rotate();
                  }
                },
                child: AspectRatio(
                  aspectRatio: TetrisController.colCount / TetrisController.rowCount,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: TetrisController.colCount,
                      ),
                      itemCount: TetrisController.rowCount * TetrisController.colCount,
                      itemBuilder: (context, index) {
                        int row = index ~/ TetrisController.colCount;
                        int col = index % TetrisController.colCount;
                
                        Color? color = tetrisController.grid[row][col];
                
                        if (tetrisController.currentBlock != null) {
                          int blockRow = tetrisController.blockRow;
                          int blockCol = tetrisController.blockCol;
                          for (int i = 0; i < tetrisController.currentBlock!.shape.length; i++) {
                            for (int j = 0; j < tetrisController.currentBlock!.shape[i].length; j++) {
                              if (tetrisController.currentBlock!.shape[i][j] == 1) {
                                if (row == blockRow + i && col == blockCol + j) {
                                  color = tetrisController.currentBlock!.color;
                                }
                              }
                            }
                          }
                        }
                
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: color ?? Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey[800]!),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Controles do jogo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ControlButton(icon: Icons.arrow_left,  onPressed:  tetrisController.moveLeft),
                ControlButton(icon: Icons.arrow_right, onPressed: tetrisController.moveRight),
                ControlButton(icon: Icons.rotate_right, onPressed: tetrisController.rotate),
                ControlButton(icon: Icons.arrow_downward, onPressed: tetrisController.moveDown),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: !tetrisController.isPlaying,
              child: ElevatedButton(
                onPressed: () {
                  if (!tetrisController.isPlaying) {
                    tetrisController.resetGrid();
                    tetrisController.startGame();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Iniciar Jogo',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
