import 'dart:io';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/register_page.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/page/widget/BlankToolBarTool.dart';
import 'package:bct_flutter/page/widget/TimerCountDownWidget.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/EventBus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sign_in_apple/sign_in_apple.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  var _onChickIndex = 0;
  var _onSeeIndex = 0;
  var _onFocus = 0;
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  TapGestureRecognizer _tapGestureRecognizer1 = new TapGestureRecognizer();
  TapGestureRecognizer _tapGestureRecognizer2 = new TapGestureRecognizer();
  TextEditingController phoneController = TextEditingController();
  TextEditingController yzmaController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();
  var bus = EventBus();

  // 光标跳转的输入框对象
  FocusNode secondTextFieldNode = FocusNode();
  FocusNode passTextFieldNode = FocusNode();
  FocusNode yzmaTextFieldNode = FocusNode();

  // 加载进度条
  Container loadingDialog;
  bool isKeyBoard = false;

  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();

  var _loginNum = 0;
  var _name = "";
  var _mail = "";
  var _userIdentify = "";
  var _authorizationCode = "";

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      //执行代码写在这里
      ScreenUtil.init(context,
          width: 750, height: 1334, allowFontScaling: false);
    });
    phoneController.addListener(() {
      setState(() {});
    });
    // Step2.1: 焦点变化时的响应

    secondTextFieldNode.addListener(() {
      if (!secondTextFieldNode.hasFocus) {
        // 失去焦点
        setState(() {
          _onFocus = 1;
        });
      } else {
        setState(() {
          _onFocus = 0;
        });
      }
    });
    yzmaTextFieldNode.addListener(() {
      if (!yzmaTextFieldNode.hasFocus) {
        // 失去焦点
        setState(() {
          _onFocus = 0;
        });
      } else {
        setState(() {
          _onFocus = 1;
        });
      }
    });
    passTextFieldNode.addListener(() {
      if (!passTextFieldNode.hasFocus) {
        // 失去焦点
        setState(() {
          _onFocus = 0;
        });
      } else {
        setState(() {
          _onFocus = 1;
        });
      }
    });
  }

  // 2.2: 焦点变化时的响应操作
  void focusNodeChange() {
    setState(() {});
  }

  // 释放对象使用的资源
  @override
  void dispose() {
    super.dispose();
    // Step3: 在销毁页面时取消监听
    blankToolBarModel.removeFocusListeners();
    _tapGestureRecognizer.dispose();
    _tapGestureRecognizer1.dispose();
    _tapGestureRecognizer2.dispose();
    phoneController.dispose();
    yzmaController.dispose();
    passController.dispose();
    //销毁
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

            // resizeToAvoidBottomPadding: true, //输入框抵住键盘
            body: BlankToolBarTool.blankToolBarWidget(context,
                showToolBar: false,
                model: blankToolBarModel,
                body: SingleChildScrollView(
                    physics: isKeyBoard
                        ? NeverScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    child: Container(
                      height: ScreenUtil.screenHeightDp + 10,
                      color: Color(AppColors.TEXT_WIT),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: ScreenUtil().setWidth(60),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(32),
                                    top: ScreenUtil().setWidth(86)),
                                child: Text("X",style: TextStyle(color: Color(AppColors.APP_ThEME),fontSize: 16),)
                                // Icon(
                                //   Icons.clear,
                                //   size: ScreenUtil().setWidth(32),
                                //   color: Color(AppColors.APP_ThEME),
                                // )
                            )
                            ,
                          ),
                          Container(
                            height: ScreenUtil().setWidth(158),
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(70)),
                            child: CachedNetworkImage(
                              width: ScreenUtil().setWidth(158),
                              height: ScreenUtil().setWidth(158),
                              fit: BoxFit.fill,
                              imageUrl:
                                  "http://snbc.zglcwl.com/Public/fontImages/ic_launcher.png",
                              //广告图片地址
//                                            placeholder: (context, url) => _buildSplashBg(),
//                                            errorWidget: (context, url, error) => _buildSplashBg(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(130),
                                left: ScreenUtil().setWidth(70)),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _onChickIndex = 0;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "登录",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: _onChickIndex == 0
                                                ? Color(AppColors.BLACK)
                                                : Color(AppColors.Text_GRAY),
                                            fontSize: ScreenUtil().setSp(
                                                _onChickIndex == 0 ? 38 : 30),
                                            decoration: TextDecoration.none),
                                      ),
                                      Offstage(
                                        offstage:
                                            _onChickIndex == 0 ? false : true,
                                        child: Container(
                                          height: ScreenUtil().setWidth(10),
                                          width: ScreenUtil().setWidth(10),
                                          decoration: new BoxDecoration(
                                            color: Color(AppColors.APP_ThEME),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(28.0)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(40)),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _onChickIndex = 1;
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "验证码登录",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: _onChickIndex == 1
                                                  ? Color(AppColors.BLACK)
                                                  : Color(AppColors.Text_GRAY),
                                              fontSize: ScreenUtil().setSp(
                                                  _onChickIndex == 1 ? 38 : 30),
                                              decoration: TextDecoration.none),
                                        ),
                                        Offstage(
                                          offstage:
                                              _onChickIndex == 1 ? false : true,
                                          child: Container(
                                            height: ScreenUtil().setWidth(10),
                                            width: ScreenUtil().setWidth(10),
                                            decoration: new BoxDecoration(
                                              color: Color(AppColors.APP_ThEME),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(28.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(70),
                                right: ScreenUtil().setWidth(70)),
                            child: Column(
                              children: <Widget>[
                                Flex(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: new TextField(
                                          // 控制器用于获取输入的内容
                                          controller: phoneController,
                                          // 键盘格式
                                          keyboardType: TextInputType.number,
                                          // 光标颜色
                                          cursorColor:
                                              Color(AppColors.APP_ThEME),
                                          // 键盘动作按钮，如“下一步”
                                          textInputAction: TextInputAction.next,
                                          // 键盘动作按钮点击之后执行的代码：

                                          //光标切换到指定的输入框
                                          onEditingComplete: () {
                                            FocusScope.of(context).requestFocus(
                                                secondTextFieldNode);
                                          },
                                          // 文本样式
                                          style: new TextStyle(
                                              color: Color(AppColors.BLACK)),
                                          decoration: InputDecoration(
                                              // 输入框边框
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left:
                                                      ScreenUtil().setWidth(10),
                                                  top: ScreenUtil()
                                                      .setHeight(40)),
                                              // 提示文字
                                              hintText: '请输入账户名',
                                              // 提示文本颜色
                                              hintStyle: new TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                  color: Color(
                                                      AppColors.TEXT_HINT))),
                                          autofocus: false, // 是否自动获取焦点
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              phoneController.clear();
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(20),
                                                top: ScreenUtil().setWidth(28)),
                                            width: ScreenUtil().setWidth(60),
                                            alignment: Alignment.centerRight,
                                            child: CachedNetworkImage(
                                              width: ScreenUtil().setWidth(32),
                                              height: ScreenUtil().setWidth(32),
                                              fit: BoxFit.fill,
                                              imageUrl:
                                                  "http://snbc.zglcwl.com/Public/fontImages/del_login_icon.png",
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                new Divider(
                                  color: Color(_onFocus == 0
                                      ? AppColors.APP_ThEME
                                      : AppColors.TEXT_CC),
                                ),
                                Offstage(
                                  offstage: _onChickIndex == 0 ? true : false,
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width:
                                                    ScreenUtil().setWidth(250),
                                                child: TextFormField(
                                                  controller: yzmaController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 4,
                                                  cursorColor: Color(
                                                      AppColors.APP_ThEME),
                                                  focusNode: yzmaTextFieldNode,
                                                  onEditingComplete: () {
//                  login();
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  style: TextStyle(
                                                    color:
                                                        Color(AppColors.BLACK),
                                                    fontSize:
                                                        ScreenUtil().setSp(28),
                                                  ),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: ScreenUtil()
                                                                  .setWidth(10),
                                                              top: ScreenUtil()
                                                                  .setHeight(
                                                                      40)),
                                                      border: InputBorder.none,
                                                      counterText: '',
                                                      hintText: '请输入验证码',
                                                      hintStyle: new TextStyle(
                                                          color: Color(AppColors
                                                              .TEXT_HINT))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(40)),
                                          child: Row(
                                            children: <Widget>[
                                              //APP_ThEME1
                                              Container(
                                                height:
                                                    ScreenUtil().setWidth(40),
                                                width: 0.5,
                                                color:
                                                    Color(AppColors.APP_ThEME1),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: ScreenUtil()
                                                        .setWidth(21)),
                                                child: TimerCountDownWidget(
                                                  phone: phoneController.text,
                                                  onTimerFinish: () {
                                                    print("倒计时结束--------");
                                                  },
                                                  reg: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Offstage(
                                  offstage: _onChickIndex == 1 ? true : false,
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: new TextField(
                                          controller: passController,
                                          keyboardType: TextInputType.url,
                                          cursorColor:
                                              Color(AppColors.APP_ThEME),
                                          focusNode: passTextFieldNode,
                                          onEditingComplete: () {
//                  login();
                                          },
                                          textInputAction: TextInputAction.done,
                                          obscureText:
                                              _onSeeIndex == 0 ? true : false,
                                          style: TextStyle(
                                            color: Color(AppColors.BLACK),
                                            fontSize: ScreenUtil().setSp(28),
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left:
                                                      ScreenUtil().setWidth(10),
                                                  top: ScreenUtil()
                                                      .setHeight(40)),
                                              border: InputBorder.none,
                                              hintText: '请输入密码',
                                              hintStyle: new TextStyle(
                                                  color: Color(
                                                      AppColors.TEXT_HINT))),
                                          autofocus: false,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (_onSeeIndex == 0) {
                                                  _onSeeIndex = 1;
                                                } else {
                                                  _onSeeIndex = 0;
                                                }
                                              });
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(20),
                                                    top: ScreenUtil()
                                                        .setHeight(28)),
                                                width:
                                                    ScreenUtil().setWidth(60),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: CachedNetworkImage(
                                                  width: ScreenUtil()
                                                      .setWidth(40),
                                                  height: ScreenUtil()
                                                      .setWidth(40),
                                                  fit: BoxFit.fill,
                                                  imageUrl: _onSeeIndex == 0
                                                      ? "http://snbc.zglcwl.com/Public/fontImages/login_unsee_icon.png"
                                                      : "http://snbc.zglcwl.com/Public/fontImages/login_see_icon.png",
                                                )),
                                          )),
                                    ],
                                  ),
                                ),
                                new Divider(
                                  color: Color(_onFocus == 1
                                      ? AppColors.APP_ThEME
                                      : AppColors.TEXT_CC),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(
                          //       right: ScreenUtil().setWidth(78),
                          //       top: ScreenUtil().setWidth(10)),
                          //   alignment: Alignment.centerRight,
                          //   child: InkWell(
                          //     onTap: () {},
                          //     child: Text(
                          //       '忘记密码？',
                          //       style: TextStyle(
                          //           color: Color(AppColors.APP_ThEME),
                          //           fontSize: ScreenUtil().setSp(24),
                          //           decoration: TextDecoration.none),
                          //     ),
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(100)),
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (!setall) {
                                  Fluttertoast.showToast(
                                      msg: "请先同意协议",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: ScreenUtil().setSp(24),
                                      textColor: Color(AppColors.TEXT_WIT),
                                      backgroundColor: Color(0xFF000000));
                                  return;
                                }
                                if (_onChickIndex == 0) {
                                  if (phoneController.text == null ||
                                      phoneController.text == "" ||
                                      passController.text == null ||
                                      passController.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "请填写完整用户名密码",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: ScreenUtil().setSp(24),
                                        textColor: Color(AppColors.TEXT_WIT),
                                        backgroundColor: Color(0xFF000000));
                                  } else {
                                    FormData formData = new FormData.fromMap({
                                      "username": phoneController.text,
                                      "pwd": passController.text,
                                    });
                                    Request.getInstance().post("/logByPwd",
                                        (data) async {
                                      DataUtils.saveLoginInfo(data)
                                          .then((value) {
                                        bus.send("updateui", "8");

                                        Navigator.pop(context);
                                      });
                                    }, params: formData);
                                  }
                                } else {
                                  if (phoneController.text == null ||
                                      phoneController.text == "" ||
                                      yzmaController.text == null ||
                                      yzmaController.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "请填写完整信息",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: ScreenUtil().setSp(24),
                                        textColor: Color(AppColors.TEXT_WIT),
                                        backgroundColor: Color(0xFF000000));
                                  } else {
                                    FormData formData = new FormData.fromMap({
                                      "username": phoneController.text,
                                    });
                                    Request.getInstance().post("/log",
                                        (data) async {
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      await sp.setString(
                                          "phone", phoneController.text);
                                      DataUtils.saveLoginInfo(data)
                                          .then((value) {
                                        bus.send("updateui", "8");
                                        Navigator.pop(context);
                                      });
                                    }, params: formData);
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(85),
                                    right: ScreenUtil().setWidth(85)),
                                height: ScreenUtil().setWidth(88),
                                decoration: BoxDecoration(
                                  border: new Border.all(
                                      width: 1,
                                      color: Color(AppColors.APP_ThEME)),
                                  color: Color(AppColors.APP_ThEME),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(28.0)),
                                ),
                                child: Center(
                                  child: Text(
                                    '登录',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(36),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(28)),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: "还没有账号。立即",
                                style: TextStyle(
                                    color: Color(AppColors.TEXT_HINT),
                                    fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: '注册',
                                    style: TextStyle(
                                        color: Color(AppColors.APP_ThEME),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                    recognizer: _tapGestureRecognizer1
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage("1")));
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(32)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        setall = !setall;
                                      });
                                    },
                                    child: Container(
                                      height: ScreenUtil().setWidth(30),
                                      width: ScreenUtil().setWidth(30),
                                      child: CachedNetworkImage(
                                        width: ScreenUtil().setWidth(30),
                                        height: ScreenUtil().setWidth(30),
                                        fit: BoxFit.fill,
                                        imageUrl: setall
                                            ? "http://snbc.zglcwl.com/Public/fontImages/dele_in_icon.png"
                                            : "http://snbc.zglcwl.com/Public/fontImages/dele_un_icon.png",
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(11)),
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "注册/登录即代表同意",
                                      style: TextStyle(
                                          color: Color(AppColors.TEXT_HINT),
                                          fontSize: ScreenUtil().setSp(22)),
                                      children: [
                                        TextSpan(
                                          text: '《用户协议》',
                                          style: TextStyle(
                                              color: Color(AppColors.BLACK),
                                              fontWeight: FontWeight.normal,
                                              fontSize: ScreenUtil().setSp(22)),
                                          recognizer: _tapGestureRecognizer
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebPage(
                                                            name: "用户协议",
                                                            url:
                                                                "http://snbc.zglcwl.com/Public/html/user.html",
                                                            isShare: false,
                                                          )));
                                            },
                                        ),
                                        TextSpan(
                                            text: '及',
                                            style: TextStyle(
                                                color:
                                                    Color(AppColors.TEXT_HINT),
                                                fontWeight: FontWeight.normal,
                                                fontSize:
                                                    ScreenUtil().setSp(22))),
                                        TextSpan(
                                          text: '《隐私政策》',
                                          style: TextStyle(
                                              color: Color(AppColors.BLACK),
                                              fontWeight: FontWeight.normal,
                                              fontSize: ScreenUtil().setSp(22)),
                                          recognizer: _tapGestureRecognizer2
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))));
  }

  var setall = false;
}
