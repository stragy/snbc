import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/register_page.dart';
import 'package:bct_flutter/page/userinfo_page.dart';
import 'package:bct_flutter/page/widget/choose_dialog_template.dart';
import 'package:bct_flutter/page/widget/list_cell.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/EventBus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'about_page.dart';
import 'download_page1.dart';
import 'login_page.dart';

class MyView extends StatefulWidget {
  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  var bus = EventBus();
  var head, nickname, username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on("updateui", (arg) {
      if (arg == "8") {
        getUserInfo();
      }
    });
    getUserInfo();
  }

  getUserInfo() {
    DataUtils.isLogin().then((value) {
      if (value) {
        DataUtils.getUserId().then((value) {
          FormData formData = new FormData.fromMap({
            "user_id": value,
          });
          Request.getInstance().post("/personal", (data) async {
            print(data);
            if (data != null) {
              setState(() {
                head = data['head'];
                print(head);
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
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(
                    'http://snbc.zglcwl.com/Public/fontImages/head_bg.png'),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25),
                  width: ScreenUtil.screenWidth,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(28)),
                        child: Image.network( head != null
                            ? head
                            : "http://snbc.zglcwl.com/Public/fontImages/head_dis.png",
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setWidth(100),
                          fit: BoxFit.fill,
                          //广告图片地址
//                                            placeholder: (context, url) => _buildSplashBg(),
//                                            errorWidget: (context, url, error) => _buildSplashBg(),
                        ),
                      ),
                      margin: EdgeInsets.only(left: 15, right: 10, top: 15),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            nickname != null ? nickname : "",
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
                        child: Image.network(
                          "http://snbc.zglcwl.com/Public/fontImages/my_next.png",
                        ),
                          width: 15,
                          height: 20,

                        margin: EdgeInsets.only(top: 10, right: 15),
                      ),
                      onTap: () {
                        DataUtils.isLogin().then((value) {
                          if (value)
                            this.pushPage(UserInfoPage());
                          else
                            _login();
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
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(50),
                  bottom: 20,
                  right: ScreenUtil().setWidth(50)),
              height: ScreenUtil().setWidth(88),
              decoration: BoxDecoration(
                color: Color(AppColors.APP_ThEME),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  "退出登录",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              ChooseDialogTemplate(
                  context: context,
                  title: null,
                  contentWidget: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '是否退出登录？',
                          style: TextStyle(
                              color: Color(0xFF434343),
                              fontSize: ScreenUtil().setSp(30),
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
        ListCell(
          icon: "/downloader_img.png",
          title: '我的下载',
          isDivider: true,
          onTap: () {
            DataUtils.isLogin().then((isLogin) {
              setState(() {
                if (isLogin) {
                  this.pushPage(DownloadPage());
                } else {
                  _login();
                }
              });
            });
          },
        ),
        ListCell(
          icon: "/about_img.png",
          title: '关于',
          isDivider: true,
          onTap: () {
            DataUtils.isLogin().then((isLogin) {
              setState(() {
                if (isLogin) {
                  this.pushPage(AboutPage());
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
                FormData formData = new FormData.fromMap({
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
                        fontSize: ScreenUtil().setSp(24),
                        textColor: Color(AppColors.TEXT_WIT),
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
                  this.pushPage(RegisterPage("2"));
                } else {
                  _login();
                }
              });
            });
          },
        ),
      ],
    );
  }

  void pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  _login() async {
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
