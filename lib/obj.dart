import 'dart:math';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String imgPath = "assets/dice/1.png";

  void play() {
    for (int i = 0; i < 20; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        setState(() {
          var r = Random();
          imgPath = "assets/dice/" + (1 + r.nextInt(6)).toString() + ".png";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Image(
                image: AssetImage(imgPath),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  play();
                },
                child: const Text(
                  "play",
                  style: TextStyle(fontSize: 50),
                )),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
