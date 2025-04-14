


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WonGameScreen extends StatefulWidget {
   final String userName;

   WonGameScreen ({super.key, required String this.userName});


  @override
  _WonGameScreenState createState() => _WonGameScreenState();
}

class _WonGameScreenState extends State<WonGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(' You Win!'),
          backgroundColor: Colors.pink[300],
          foregroundColor: Colors.white,
        ),
        body: Center(
    child: Column(

    mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text('Congratulations ${widget.userName} ', style: TextStyle(fontSize: 24)),
    Image(image: AssetImage('assets/images/winner.jpg'), height: 350,),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () {
    Navigator.pop(context);
    },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
      ),
    child: Text('Play Again'),
    ),
    ])));

  }
}