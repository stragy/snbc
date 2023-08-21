import 'dart:ui';

import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class AppBarUtils {
  static AppBar appBar(String title, BuildContext context,
      [Widget leading, List<Widget> actions]) {
    void backAction() {
      Navigator.pop(context,"refresh");
    }

    return AppBar(
      backgroundColor: Color(AppColors.APP_ThEME),
      title: Text(
        title,
        style: TextStyle(
            color:  Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 18,
            fontFamily: 'PingFang'),
      ),
      centerTitle: true,
      leading: leading ??
          IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.white, size: 20),
            onPressed: backAction,
          ),
      actions: actions,
    );
  }
}

class DeviceUtils {
  static bool iPhoneXAbove(BuildContext context) {
    return (DeviceUtils.sreenWidth(context) >= 375 &&
        DeviceUtils.sreenHeight(context) >= 812);
  }

  static double sreenWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width);
  }

  static double sreenHeight(BuildContext context) {
    return (MediaQuery.of(context).size.height);
  }

}
