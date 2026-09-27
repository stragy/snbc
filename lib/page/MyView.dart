// ignore_for_file: file_names
import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/register_page.dart';
import 'package:bct_flutter/page/userinfo_page.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/page/widget/choose_dialog_template.dart';
import 'package:bct_flutter/page/widget/list_cell.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'about_page.dart';
import 'login_page.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  var bus = EventBus();
  String? head, nickname, username;

  @override
  void initState() {
    super.initState();
    bus.on("updateui", (arg) {
      if (arg == "8") {
        getUserInfo();
      }
    });
    getUserInfo();
  }

  void getUserInfo() {
    DataUtils.isLogin().then((value) {
      if (value) {
        DataUtils.getUserId().then((value) {
          FormData formData = FormData.fromMap({
            "user_id": value,
          });
          Request.getInstance().post("/personal", (data) async {
            debugPrint('$data');
            if (data != null) {
              setState(() {
                head = data['head'];
                debugPrint('$head');
                username = data['username'];
                nickname = data['nickname'];
              });
            } else {
              setState(() {
                head = null;
                username = null;
                nickname = null;
              });
            }
          }, params: formData);
        });
      } else {
        setState(() {
          head = null;
          username = null;
          nickname = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppAssets.headBg),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25),
                  width: 1.sw,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    "个人中心",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 10, top: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(28)),
                        child: Image.asset(
                          head ??
                              AppAssets.headDis,
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.fill,
                          //广告图片地址
//                                            placeholder: (context, url) => _buildSplashBg(),
//                                            errorWidget: (context, url, error) => _buildSplashBg(),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            nickname ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            username != null ? "账号：$username" : "",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )
                      ],
                    )),
                    GestureDetector(
                      child: Container(
                        width: 15,
                        height: 20,
                        margin: EdgeInsets.only(top: 10, right: 15),
                        child: Image.network(
                          AppAssets.myNext,
                        ),
                      ),
                      onTap: () {
                        DataUtils.isLogin().then((value) {
                          if (value) {
                            pushPage(UserInfoPage());
                          } else {
                            _login();
                          }
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 50.w, bottom: 20, right: 50.w),
              height: 88.w,
              decoration: BoxDecoration(
                color: Color(AppColors.APP_THEME),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  "退出登录",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              chooseDialogTemplate(
                  context: context,
                  title: '',
                  contentWidget: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '是否退出登录？',
                          style: TextStyle(
                              color: Color(0xFF434343),
                              fontSize: 30.sp,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                  cancelCallback: () {
//                Navigator.pop(context);
                  },
                  confirmCallBack: () {
                    DataUtils.clearLoginInfo();
                    setState(() {
                      username = null;
                      nickname = null;
                      head = null;
                    });
                    _login();
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        ListCell(
          icon: "/personal_img.png",
          title: '个人信息',
          isDivider: true,
          onTap: () {
            DataUtils.isLogin().then((isLogin) {
              setState(() {
                if (isLogin) {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInfoPage()))
                      .then((value) => getUserInfo());
                } else {
                  _login();
                }
              });
            });
          },
        ),
        // ListCell(
        //   icon: "/downloader_img.png",
        //   title: '我的下载',
        //   isDivider: true,
        //   onTap: () {
        //     DataUtils.isLogin().then((isLogin) {
        //       setState(() {
        //         if (isLogin) {
        //           this.pushPage(DownloadPage());
        //         } else {
        //           _login();
        //         }
        //       });
        //     });
        //   },
        // ),
        ListCell(
          icon: "/about_img.png",
          title: '关于',
          isDivider: true,
          onTap: () {
            DataUtils.isLogin().then((isLogin) {
              setState(() {
                if (isLogin) {
                  pushPage(AboutPage());
                } else {
                  _login();
                }
              });
            });
          },
        ),
        ListCell(
          icon: "/service_img.png",
          title: '客服',
          isDivider: true,
          onTap: () {
            DataUtils.isLogin().then((isLogin) {
              if (isLogin) {
                FormData formData = FormData.fromMap({
                  "name": nickname,
                  "tel": username,
                });
                Request.getInstance().post("/service", (data) async {
                  setState(() {
                    Fluttertoast.showToast(
                        msg: "已收到您的建议，客服在两个小时内回电，请保持手机畅通。",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        fontSize: 24.sp,
                        textColor: Color(AppColors.TEXT_WHITE),
                        backgroundColor: Color(0xFF000000));
                  });
                }, params: formData);
              } else {
                _login();
              }
            });
          },
        ),
        ListCell(
          icon: "/setting_img.png",
          title: '设置密码',
          isDivider: true,
          onTap: () {
            DataUtils.isLogin().then((isLogin) {
              setState(() {
                if (isLogin) {
                  pushPage(RegisterPage("2"));
                } else {
                  _login();
                }
              });
            });
          },
        ),
        ListCell(
          icon: "/setting_img.png",
          title: '用户协议',
          isDivider: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebPage(
                          name: "用户协议",
                          url: "http://snbc.zglcwl.com/Public/html/user.html",
                          isShare: false,
                        )));
          },
        ),
        ListCell(
          icon: "/setting_img.png",
          title: '隐私政策',
          isDivider: true,
          onTap: () {
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
      ],
    );
  }

  void pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _login() async {
    // 打开登录页并处理登录成功的回调
    final result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
    // result为"refresh"代表登录成功
    if (result != null && result == "refresh") {
      // 刷新用户信息
      getUserInfo();
      // 通知动弹页面刷新
      bus.send("updateui", "8");
    }
  }
}
