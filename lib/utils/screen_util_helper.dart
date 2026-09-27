import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Helper class to provide backward compatibility with older ScreenUtil usage
/// This bridges the gap between the old ScreenUtil API and the new one
class ScreenUtilHelper {
  // Design size constants - adjust these to match your original design size
  static const double designWidth = 750;
  static const double designHeight = 1334;

  // Singleton instance
  static final ScreenUtilHelper _instance = ScreenUtilHelper._internal();

  factory ScreenUtilHelper() {
    return _instance;
  }

  ScreenUtilHelper._internal();

  // Width and height getters that mimic the old static accessors
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;
  static double get screenWidthDp => ScreenUtil().screenWidth;
  static double get screenHeightDp => ScreenUtil().screenHeight;

  // Initialize method to be called in main.dart
  static Widget init({required Widget child}) {
    return ScreenUtilInit(
      designSize: const Size(designWidth, designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return child;
      },
    );
  }

  // Helper methods to convert values based on design size
  static double setWidth(double width) {
    return width.w;
  }

  static double setHeight(double height) {
    return height.h;
  }

  static double setSp(double fontSize) {
    return fontSize.sp;
  }

  static double setRadius(double radius) {
    return radius.r;
  }
}

// We don't need to define our own extension methods since flutter_screenutil already provides them
// Just use the ones from the package directly
