import 'package:demo/controller/dice.ctrl.dart';
import 'package:demo/design/utils/colors.styles.dart';
import 'package:demo/design/utils/text_styles.styles.dart';
import 'package:demo/views/reward.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final DiceController ctrl = Get.put<DiceController>(DiceController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: DesignColors.secBg,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 40.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Roll The Dice ✌️',
                style: DesignText.headingOne(color: DesignColors.primary),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Shake your phone or Press the Start button to roll the dices and start playing',
                style: DesignText.subHeading(color: DesignColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 145.h,
              ),
              Container(
                width: 325.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 20.h,
                ),
                decoration: const BoxDecoration(
                  color: DesignColors.background,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 100.w,
                          child: Image.asset(
                            ctrl.dice1.value,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 100.w,
                          height: 100.w,
                          child: Image.asset(
                            ctrl.dice2.value,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 200.h,
              ),
              InkWell(
                onTap: () {
                  ctrl.play();
                  Future.delayed(const Duration(seconds: 2)).then((_) {
                    ctrl.calcScore();
                    Get.to(() => RewardView());
                  });
                },
                child: Container(
                  height: 55.h,
                  width: 325.w,
                  decoration: const BoxDecoration(
                    color: DesignColors.card,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      'Start',
                      style: DesignText.bText(
                        color: DesignColors.background,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
