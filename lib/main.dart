import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MemoryGameScreen());
}

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final List<String> imagePaths = [
    "assets/images/cowboy.jpg",
    "assets/images/skimask.jpg",
    "assets/images/elf.jpeg",
    "assets/images/ghost.jpg",
    "assets/images/glitterHat.tiff",
    "assets/images/greysweater.jpeg",
    "assets/images/hawaii.jpg",
    "assets/images/hiphop.jpg",
    "assets/images/nose.tiff",
    "assets/images/glasses.jpg",
    "assets/images/sunglasses.jpeg",
    "assets/images/superman.jpg",
    "assets/images/sweater.jpg",
    "assets/images/witch.tiff"
  ];

  List<String> gameImages = [];
  List<bool> flippedCards = []; // Track flipped state

  @override
  void initState() {
    super.initState();
    setupGame();
  }

  void setupGame() {
    setState(() {
      gameImages = [...imagePaths, ...imagePaths];
      gameImages.shuffle(Random());
      flippedCards = List.generate(gameImages.length, (index) => false);
    });
  }

  void flipCard(int index) {
    setState(() {
      flippedCards[index] = !flippedCards[index];
    });
  }

  void restartGame() {
    setupGame();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Game restarted!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: const Text('Memory Game'),
          backgroundColor: Colors.pink[300],
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: restartGame,
              tooltip: "Restart Game",
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: gameImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  flipCard(index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: flippedCards[index]
                      ? Image.asset(
                    gameImages[index],
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.blue,
                    child: const Center(child: Text("Tap to flip",
                      style: TextStyle(color: Colors.white),)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

