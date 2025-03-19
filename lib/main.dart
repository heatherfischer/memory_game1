import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text('Memory Game'),
          backgroundColor: Colors.pink[300],
        ),
      ),
    ),
  );
}
