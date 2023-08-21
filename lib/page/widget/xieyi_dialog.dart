import 'dart:io';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../home_page.dart';

Future<String> XieyiDialog(context1) {
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  TapGestureRecognizer _tapGestureRecognizer2 = new TapGestureRecognizer();
  // 释放对象使用的资源
  showDialog<Null>(

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
                      width:300,
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom: 20),
                      decoration: new BoxDecoration(
                        color: Color(AppColors.TEXT_WIT),
                        borderRadius: BorderRadius.all(
                            Radius.circular(8)),
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
                    width:300,
                    padding: EdgeInsets.only(
                        bottom: 25,left:23 ,right:23,
                        top: 25),
                    alignment: Alignment.centerLeft,
                    child:
                    Container(
                      width: 300,
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: "请务必详细阅读，充分理解",
                          style: TextStyle(
                              color: Color(AppColors.BLACK),
                              fontSize: 14),
                          children: [
                            TextSpan(
                              text: '《用户协议》',
                              style: TextStyle(
                                  color: Color(AppColors.APP_ThEME1),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                              recognizer: _tapGestureRecognizer
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(name:"用户协议",url: "http://snbc.zglcwl.com/Public/html/user.html",isShare: false,)));
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
                                  color: Color(AppColors.APP_ThEME1),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                              recognizer: _tapGestureRecognizer2
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(name: "隐私政策",url: "http://snbc.zglcwl.com/Public/html/agreement.html",isShare: false)));
                                },
                            ),
                            TextSpan(
                              text: '各条款；为了向提供更好的服务，会需要您授权地理位置和相机权限。你你可以在个人页查看和变更协议。你可阅读《服务协议和隐私政策》了解详细信息。如你同意，请点击同意开始接受我们的服务。',
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
                          border: new Border.all(
                            width: 1,
                            color: Color(AppColors.TEXT_HINT),
                          ),
                          color: Color(AppColors.TEXT_HINT),
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        ),
                        child: RaisedButton(
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
                          color: Color(AppColors.TEXT_WIT),
                          onPressed: () {
                            exit(0);
                          },

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ), //圆角大小
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 11,
                            right: 11),
                        width:100,
                        height: 34,
                        child: RaisedButton(
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
                          color: Color(AppColors.APP_ThEME),
                          onPressed: () {
                            Navigator.pop(context);
                            DataUtils.setFirst(true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );

                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ), //圆角大小
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
}
