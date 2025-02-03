import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/tetris/controller/tetris_controller.dart';
import 'package:tetris_app/tetris/tetris_page/tetris_page.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TetrisController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jogos',
        home: const TetrisPage(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}


