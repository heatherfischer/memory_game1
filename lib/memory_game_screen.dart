import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memory_game1/cat_photos_screen.dart';
import 'package:memory_game1/won_game_screen.dart';

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
    "assets/images/glitterHat.jpg",
    "assets/images/greysweater.jpeg",
    "assets/images/hawaii.jpg",
    "assets/images/hiphop.jpg",
    "assets/images/nose.jpg",
    "assets/images/glasses.jpg",
    "assets/images/sunglasses.jpeg",
    "assets/images/superman.jpg",
    "assets/images/sweater.jpg",
    "assets/images/witch.jpg",
  ];

  List<String> currentCards = [];
  List<bool> flippedCards = [];
  int matchesFound = 0;
  List<int> flippedIndexes = [];
  bool isChecking = false; // Prevent multiple clicks

  int _difficulty = 1; // Default: Medium
  int _gridSize = 4; // Default grid size

  late TextEditingController textController;
  String savedUserName = '';

  void _setDifficulty(int value) {
    setState(() {
      _difficulty = value;
      switch (_difficulty) {
        case 0:
          _gridSize = 3;
          break; // Easy
        case 1:
          _gridSize = 4;
          break; // Medium
        case 2:
          _gridSize = 5;
          break; // Hard
        default:
          _gridSize = 4;
      }
      setupGame();
    });
  }

  @override
  void initState() {
    super.initState();

    // Wait until the first frame is rendered before showing the modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoginModal();
    });

    savedUserName = '';
    textController = TextEditingController();
    super.initState();
    setupGame();
  }

  void setupGame() {
    int numPairs =
        (_gridSize * _gridSize) ~/ 2; // Adjust pairs to match grid size
    List<String> selectedImages = imagePaths.sublist(
      0,
      numPairs,
    ); // Limit images
    currentCards = [...selectedImages, ...selectedImages]; // Create pairs
    currentCards.shuffle(Random());

    setState(() {
      flippedCards = List.generate(currentCards.length, (index) => false);
      matchesFound = 0;
      flippedIndexes.clear();
    });
  }

  void flipCard(int index) {
    if (isChecking || flippedCards[index]) return;

    setState(() {
      flippedCards[index] = true;
      flippedIndexes.add(index);
    });

    if (flippedIndexes.length == 2) {
      isChecking = true;
      Future.delayed(const Duration(seconds: 1), () {
        checkMatch();
      });
    }
  }

  void checkMatch() {
    if (flippedIndexes.length == 2) {
      int firstIndex = flippedIndexes[0];
      int secondIndex = flippedIndexes[1];

      if (currentCards[firstIndex] != currentCards[secondIndex]) {
        setState(() {
          flippedCards[firstIndex] = false;
          flippedCards[secondIndex] = false;
        });
      } else {
        setState(() {
          matchesFound++;
        });
        checkForWin();
      }
    }

    flippedIndexes.clear();
    isChecking = false;
  }

  void checkForWin() {
    if (matchesFound == currentCards.length / 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WonGameScreen(userName: savedUserName),
        ),
      );
    }
  }

  void restartGame() {
    setupGame();
    showLoginModal();
  }

  void showLoginModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Your Name Here',
                    helperText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String name = textController.text;
                  savedUserName = name;
                  print('saved user name: $name');
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Riva\'s Memory Game'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.pink[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: restartGame,
            tooltip: "Restart Game",
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Select Difficulty", style: TextStyle(fontSize: 18)),
          Slider(
            value: _difficulty.toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            label: ["Easy", "Medium", "Hard"][_difficulty],
            onChanged: (value) => _setDifficulty(value.toInt()),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: currentCards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => flipCard(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          flippedCards[index]
                              ? Image.asset(
                                currentCards[index],
                                fit: BoxFit.cover,
                              )
                              : const MemoryCard(),
                    ),
                  );
                },
              ),
            ),
          ),
          BottomAppBar(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Matches Found: $matchesFound",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CatPhotos()),
                      );
                    },
                    child: const Text("Cat Photos"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modify Container widget to make custom widget
class MemoryCard extends StatelessWidget {
  const MemoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text("Tap to flip", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
