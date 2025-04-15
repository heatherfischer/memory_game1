import 'package:flutter/material.dart';

import 'package:memory_game1/memory_game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue[100]),
      home: MemoryGameScreen(),
    );
  }
}
