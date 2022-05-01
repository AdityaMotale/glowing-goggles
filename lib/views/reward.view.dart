import 'package:demo/controller/dice.ctrl.dart';
import 'package:demo/design/utils/assets.styles.dart';
import 'package:demo/design/utils/colors.styles.dart';
import 'package:demo/design/utils/text_styles.styles.dart';
import 'package:demo/scratchy/scratchy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RewardView extends StatelessWidget {
  RewardView({Key? key}) : super(key: key);

  final DiceController ctrl = Get.find<DiceController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: DesignColors.secBg,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Congratulations 🎉',
                style: DesignText.headingOne(color: DesignColors.primary),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Here is your scratch card',
                style: DesignText.subHeading(color: DesignColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                height: 350.h,
                width: 325.w,
                child: Scratchy(
                  color: Colors.transparent,
                  image: Image.asset(
                    "assets/gift.png",
                    fit: BoxFit.fill,
                  ),
                  onChange: (val) {
                    if (val > 20) {
                      ctrl.isScratched.value = true;
                    } else {
                      ctrl.isScratched.value = false;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DesignColors.card),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250.h,
                          child: Image.asset(DesignAssets.congo),
                        ),
                        Text(
                          "Hey! You Won",
                          style: DesignText.titleOne(
                            color: DesignColors.background,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "${ctrl.score} points",
                          style: DesignText.titleOne(
                            color: DesignColors.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Scratch the above card by swiping on it and get your reward',
                style: DesignText.subHeading(color: DesignColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30.h,
              ),
              Obx(
                () => ctrl.isScratched.value
                    ? InkWell(
                        onTap: () {
                          ctrl.isScratched.value = false;
                          Get.back();
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
                              'Play again',
                              style: DesignText.bText(
                                color: DesignColors.background,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 55.h,
                      ),
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
