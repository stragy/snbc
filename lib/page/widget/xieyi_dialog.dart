import 'dart:io';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<String> xieyiDialog(BuildContext context1) async {
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  TapGestureRecognizer tapGestureRecognizer2 = TapGestureRecognizer();
  // 释放对象使用的资源
  await showDialog<Null>(
    context: context1,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        // 手势处理事件

        backgroundColor: Colors.transparent,
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: SafeArea(
                child: Center(
                    child: Container(
              width: 300,
              padding: EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Color(AppColors.TEXT_WHITE),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 25),
                    child: Text(
                      '服务协议和隐私政策',
                      style: TextStyle(
                        fontFamily: "familyFontStyle",
                        color: Color(AppColors.BLACK),
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 300,
                    padding: EdgeInsets.only(
                        bottom: 25, left: 23, right: 23, top: 25),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 300,
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: "请务必详细阅读，充分理解",
                          style: TextStyle(
                              color: Color(AppColors.BLACK), fontSize: 14),
                          children: [
                            TextSpan(
                              text: '《用户协议》',
                              style: TextStyle(
                                  color: Color(AppColors.APP_THEME_LIGHT),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                              recognizer: tapGestureRecognizer
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(
                                                name: "用户协议",
                                                url:
                                                    "http://snbc.zglcwl.com/Public/html/user.html",
                                                isShare: false,
                                              )));
                                },
                            ),
                            TextSpan(
                                text: '和',
                                style: TextStyle(
                                    color: Color(AppColors.BLACK),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                            TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                  color: Color(AppColors.APP_THEME_LIGHT),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                              recognizer: tapGestureRecognizer2
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(
                                              name: "隐私政策",
                                              url:
                                                  "http://snbc.zglcwl.com/Public/html/agreement.html",
                                              isShare: false)));
                                },
                            ),
                            TextSpan(
                              text:
                                  '各条款；我们接入穿山甲广告SDK，用于在应用启动时展示开屏广告。该SDK可能会收集设备标识符（如OAID）、设备型号、操作系统版本、网络类型等信息，用于广告投放与效果评估。你你可以在个人页查看和变更协议。你可阅读《服务协议和隐私政策》了解详细信息。如你同意，请点击同意开始接受我们的服务。',
                              style: TextStyle(
                                  color: Color(AppColors.BLACK),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
//                    Text(
//                      "请务必详细阅读，充分理解《服务协议和隐私政策》各条款；为了向提供更好的服务，会需要您授权地理位置和相机权限。你你可以在个人页查看和变更协议。" +
//                          "你可阅读《服务协议和隐私政策》了解详细信息。如你同意，请点击同意开始接受我们的服务",
//                      maxLines: 6,
//                      style: TextStyle(
//                        color: Color(AppColors.BLACK),
//                        fontSize: ScreenUtil().setSp(28),
//                      ),
//                      textAlign: TextAlign.left,
//                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 34,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(AppColors.TEXT_HINT),
                          ),
                          color: Color(AppColors.TEXT_HINT),
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppColors.TEXT_WHITE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                          onPressed: () {
                            exit(0);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '拒绝',
                              style: TextStyle(
                                color: Color(AppColors.Text_GRAY),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 11, right: 11),
                        width: 100,
                        height: 34,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppColors.APP_THEME),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            // 标记已同意协议（isFirst=false，下次启动不再弹窗）
                            await DataUtils.setFirst(false);
                            // 通知 SplashPage：用户已同意，可初始化广告并展示开屏后进入首页
                            EventBus().send("goHome");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '同意',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))),
          ),
        ],
      );
    },
  );
  return '';
}
