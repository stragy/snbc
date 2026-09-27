import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;

// ignore: must_be_immutable
class DialogShare extends StatefulWidget {
  const DialogShare({super.key, this.url = ''});
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
    return StatefulBuilder(
      builder: (context, state) {
        return SizedBox(
          height: 176,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "选择要使用的应用",
                  style: TextStyle(
                    color: Color(AppColors.TEXT_BLACK),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            AppAssets.wechatImg,
                            width: 52,
                            height: 52,
                            fit: BoxFit.fill,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "微信",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.TEXT_BLACK),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _share(widget.url, "神农百草", WeChatScene.session);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 30),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            AppAssets.circleOfFriends,
                            width: 52,
                            height: 52,
                            fit: BoxFit.fill,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "朋友圈",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.TEXT_BLACK),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _share(widget.url, "神农百草", WeChatScene.timeline);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _share(String url, String title, WeChatScene scene) async {
    // Temporarily disabled for web platform
    debugPrint("WeChat share not available on web platform");
    debugPrint("URL: $url, Title: $title, Scene: $scene");
    
    // var model = fluwx.WeChatShareWebPageModel(
    //   url,
    //   title: title,
    //   description: title,
    //   scene: scene,
    // );
    // try {
    //   await fluwx.share(model);
    // } catch (e) {
    //   debugPrint("WeChat share failed: $e");
    // }
  }
}
