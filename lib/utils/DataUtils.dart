import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/UserInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUtils {
  static const String UserName = "username";
  static const String NickName = "nickName";
  static const String SP_UID = "id";

  static const String SP_IS_LOGIN = "isLogin";
  static const String SP_USER_NAME = "name";
  static const String SP_USER_ID = "id";
  static const String SP_USER_LOC = "location";
  static const String SP_USER_GENDER = "gender";
  static const String SP_USER_AVATAR = "avatar";
  static const String SP_USER_EMAIL = "email";
  static const String SP_USER_URL = "url";
  static const String SP_COLOR_THEME_INDEX = "colorThemeIndex";

  // 保存用户登录信息，data中包含了token等信息
  static Future<String> saveLoginInfo(Map data) async {
    if (data != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = data['username'];
      await sp.setString(UserName, token);
      String nickName = data['nickname'];
      await sp.setString(NickName, nickName);
      String uid = data['user_id'];
      await sp.setString(SP_UID, uid);
      await sp.setBool(SP_IS_LOGIN, true);
      return "1";
    }
  }

  // 清除登录信息
  static Future<bool> clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(UserName, "");
    await sp.setString(NickName, "");
    await sp.setString(SP_UID, "");
    await sp.setBool(SP_IS_LOGIN, false);
    return true;
  }

  // 是否登录
  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool b = sp.getBool(SP_IS_LOGIN);
    return b != null && b;
  }

  // 获取accesstoken
  static Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(SP_UID);
  }
  static Future<String> getPhone() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("phone");
  }

  static Future imageCompressToFile(File file) async {
    //print('压缩前图片文件大小:' + file.lengthSync().toString());
    File imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      Directory.systemTemp.path +
          '/userava' +
          DataUtils.getRandomString() +
          '.jpg',
      minWidth: 800,
      minHeight: 800,
    );
    //print('压缩后图片文件大小:' + imageFile.lengthSync().toString());
    //print('压缩后路径:' + imageFile.path + imageFile.absolute.path);
    return imageFile;
  }
  static String getRandomString() {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = 5;

    // 生成的字符串固定长度
    String indicator = '';
    for (var i = 0; i < strlenght; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      indicator = indicator + alphabet[Random().nextInt(alphabet.length)];
    }
    return indicator;
  }


  // 获取本地存值对象
  static Future<String> getPreserve(parameter) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(parameter);
  }

  //设置本地存值
  static Future setPreserve(parameter, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(parameter, value);
  }

  // 获取存储路径
  Future<String> findLocalPath(context) async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory.path;
  }
  // 申请权限
  Future<bool> checkPermission(context) async {
    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
  downloadFile(downloadUrl, savePath) async {
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: savePath,
      showNotification: false,
      fileName: "神农百草.apk",

      // show download progress in status bar (for Android)
      openFileFromNotification:
      true,
      // click on notifi
      // cation to open downloaded file (for Android)
    );
  }
  static ShowTos(message,{Lonngt = Toast.LENGTH_SHORT }) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Lonngt,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: ScreenUtil().setSp(24),
        textColor: Color(AppColors.TEXT_WIT),
        backgroundColor: Color(0xFF000000));
  }

  // 根据taskId打开下载文件
  Future<bool> openDownloadedFile(taskId) {
    return FlutterDownloader.open(taskId: taskId);
  }
  static setFirst(bool version) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("isFirst", version);
  }

  static Future<bool> isFirst() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool("isFirst");
  }


}
