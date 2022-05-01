import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesignText {
  static TextStyle headingOne({required Color color}) => TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle subHeading({required Color color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w300,
        color: color,
      );
  static TextStyle titleOne({required Color color}) => TextStyle(
        fontSize: 30.sp,
        fontWeight: FontWeight.w900,
        color: color,
      );
  static TextStyle titleTwo({required Color color}) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w900,
        color: color,
      );
  static TextStyle bText({required Color color}) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: color,
      );
}
