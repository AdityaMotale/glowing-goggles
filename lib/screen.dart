import 'dart:developer';

import 'package:demo/scratch_card.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

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
        child: ScratchCard(
          color: Colors.red,
          threshold: 40,
          child: Container(
            width: 300,
            height: 300,
            color: Colors.yellowAccent,
          ),
          image: Image.network('src'),
        ),
      ),
    );
  }
}

// Scratcher(
//           color: Colors.red,
//           brushSize: 35,
//           threshold: 40,
//           onChange: (value) => log("$value%  Scratched"),
//           onThreshold: () => log("Reached Threshold..!!"),
//           child: Container(
//             height: 300,
//             width: 300,
//             color: Colors.green,
//           ),
//         )