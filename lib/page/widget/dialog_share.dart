import 'dart:async';

import 'package:bct_flutter/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

// ignore: must_be_immutable
class DialogShare extends StatefulWidget {
  DialogShare({
    Key key,
    this.url

  }) : super(key: key);
  final String url;

  @override
  State<DialogShare> createState() => _DialogShare();
}

class _DialogShare extends State<DialogShare> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StatefulBuilder(
      builder: (context, state) {
        return new Container(
          height: 176,
          child: new Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "选择要使用的应用",
                  style: TextStyle(
                      color: Color(AppColors.TEXT_BLACK),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              new Row(
                children: <Widget>[
                  GestureDetector(
                    child: new Container(
                      margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                      child: new Column(
                        children: <Widget>[
                          CachedNetworkImage(
                            width: 52,
                            height: 52,
                            fit: BoxFit.fill,
                            imageUrl: "http://snbc.zglcwl.com/Public/fontImages/wechat_img.png",
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              "微信",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(AppColors.TEXT_BLACK),
                            ),
                          ))
                        ],
                      ),
                    ),
                    onTap: () {
                      _share(widget.url, "神农百草",
                          WeChatScene.SESSION);
                    },
                  ),
                  GestureDetector(
                    child: new Container(
                      margin: EdgeInsets.only(top: 10, left: 30),
                      child: new Column(
                        children: <Widget>[
                          CachedNetworkImage(
                            width: 52,
                            height: 52,
                            fit: BoxFit.fill,
                            imageUrl: "http://snbc.zglcwl.com/Public/fontImages/circle_of_friends.png",
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              "朋友圈",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(AppColors.TEXT_BLACK)),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _share(
                          widget.url,
                          "神农百草",
                          WeChatScene.TIMELINE);
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _share(String url, String title,  WeChatScene scene) {
    var model = fluwx.WeChatShareWebPageModel(
        webPage: url,
        title: title,
        scene: scene,
        transaction: "hh");
    fluwx.shareToWeChat(model);
//    fluwx.responseFromShare.listen((data){
//      Fluttertoast.showToast(msg:  data.errCode.toString()+"  "+data.errStr.toString());
//    });
  }
}
