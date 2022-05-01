import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:demo/design/utils/assets.styles.dart';
import 'package:get/get.dart';

class DiceController extends GetxController {
  RxString dice1 = (DesignAssets.dicePrefix + '1.png').obs;
  RxString dice2 = (DesignAssets.dicePrefix + '4.png').obs;
  RxInt score = 0.obs;
  RxBool isScratched = false.obs;

  AudioCache player = AudioCache(prefix: DesignAssets.dicePrefix);

  @override
  void onInit() {
    super.onInit();
    player.load(
      DesignAssets.diceAudio,
    );
  }

  Future<void> play() async {
    for (int i = 0; i < 20; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        var r = Random();
        int r1 = 1 + r.nextInt(6);
        int r2 = 1 + r.nextInt(6);
        dice1.value = (DesignAssets.dicePrefix) + r1.toString() + '.png';
        dice2.value = (DesignAssets.dicePrefix) + r2.toString() + '.png';
      });
    }
  }

  void calcScore() {
    final int score1 = int.parse(dice1.value.substring(7, 8));
    final int score2 = int.parse(dice2.value.substring(7, 8));
    final int total = score1 + score2;
    if (total == 12) {
      score.value = 100;
    } else {
      score.value = (total * 8.34).round();
    }
    dev.log("Your Score is ${score.value}");
  }
}
