import 'package:demo/scratchy/scratchy.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        child: Scratchy(
          color: Colors.red,
          threshold: 40,
          child: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: const [
                Text(
                  'Hey! You got 20 points',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text('Hey! You got 20 points'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
