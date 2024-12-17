import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedAnimation = "idle"; // Default animation

  // List các animation có sẵn trong file FLR
  List<String> animations = [
    "idle",
    "happy",
    "sad",
    "angry",
    "surprised",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flare Animation Example"),
      ),
      body: Center(
        child: FlareActor("assets/all/animated_icons.flr"
        , alignment:Alignment.center,
         fit:BoxFit.contain, animation:"chat_bubble"),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}
