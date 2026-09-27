import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/register_page.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/page/widget/blank_tool_bar_tool.dart';
import 'package:bct_flutter/page/widget/timer_count_down_widget.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:bct_flutter/utils/screen_util_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sign_in_apple/sign_in_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  var _onChickIndex = 0;
  var _onSeeIndex = 0;
  var _onFocus = 0;
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _tapGestureRecognizer1 = TapGestureRecognizer();
  final TapGestureRecognizer _tapGestureRecognizer2 = TapGestureRecognizer();
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
  late Container loadingDialog;
  bool isKeyBoard = false;

  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "取消",
              style: TextStyle(color: Color(AppColors.APP_TEXT_999)),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        // brightness: Brightness.light, // Deprecated
        // 使用 systemOverlayStyle 替代
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

        // resizeToAvoidBottomPadding: true, //输入框抵住键盘
        body: BlankToolBarTool.blankToolBarWidget(context,
            showToolBar: false,
            model: blankToolBarModel,
            body: SingleChildScrollView(
                physics: isKeyBoard
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                child: Container(
                  height: ScreenUtilHelper.screenHeightDp + 10,
                  color: Color(AppColors.TEXT_WHITE),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 60.w,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 32.w, top: 86.w),
                            child: Text(
                              "X",
                              style: TextStyle(
                                  color: Color(AppColors.APP_THEME),
                                  fontSize: 16),
                            )
                            ),
                      ),
                      Container(
                        height: 158.w,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 70.w),
                        child: Image.asset(
                          AppAssets.icLauncher,

                          width: 158.w,
                          height: 158.w,
                          fit: BoxFit.fill,
//                                            placeholder: (context, url) => _buildSplashBg(),
//                                            errorWidget: (context, url, error) => _buildSplashBg(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 130.w, left: 70.w),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _onChickIndex = 0;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "登录",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: _onChickIndex == 0
                                            ? Color(AppColors.BLACK)
                                            : Color(AppColors.Text_GRAY),
                                        fontSize:
                                            (_onChickIndex == 0 ? 38 : 30).sp,
                                        decoration: TextDecoration.none),
                                  ),
                                  Offstage(
                                    offstage: _onChickIndex == 0 ? false : true,
                                    child: Container(
                                      height: 10.w,
                                      width: 10.w,
                                      decoration: BoxDecoration(
                                        color: Color(AppColors.APP_THEME),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(28.0)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 40.w),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _onChickIndex = 1;
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "验证码登录",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: _onChickIndex == 1
                                              ? Color(AppColors.BLACK)
                                              : Color(AppColors.Text_GRAY),
                                          fontSize:
                                              (_onChickIndex == 1 ? 38 : 30).sp,
                                          decoration: TextDecoration.none),
                                    ),
                                    Offstage(
                                      offstage:
                                          _onChickIndex == 1 ? false : true,
                                      child: Container(
                                        height: 10.w,
                                        width: 10.w,
                                        decoration: BoxDecoration(
                                          color: Color(AppColors.APP_THEME),
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
                        margin: EdgeInsets.only(left: 70.w, right: 70.w),
                        child: Column(
                          children: <Widget>[
                            Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                    flex: 3,
                                    child: TextField(
                                      // 控制器用于获取输入的内容
                                      controller: phoneController,
                                      // 键盘格式
                                      keyboardType: TextInputType.number,
                                      // 光标颜色
                                      cursorColor: Color(AppColors.APP_THEME),
                                      // 键盘动作按钮，如"下一步"
                                      textInputAction: TextInputAction.next,
                                      // 键盘动作按钮点击之后执行的代码：

                                      //光标切换到指定的输入框
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(secondTextFieldNode);
                                      },
                                      // 文本样式
                                      style: TextStyle(
                                          color: Color(AppColors.BLACK)),
                                      decoration: InputDecoration(
                                          // 输入框边框
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 10.w, top: 40.h),
                                          // 提示文字
                                          hintText: '请输入账户名',
                                          // 提示文本颜色
                                          hintStyle: TextStyle(
                                              fontSize: 28.sp,
                                              color:
                                                  Color(AppColors.TEXT_HINT))),
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
                                            right: 20.w, top: 28.w),
                                        width: 60.w,
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          AppAssets.delLoginIcon,
                                          width: 32.w,
                                          height: 32.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            Divider(
                              color: Color(_onFocus == 0
                                  ? AppColors.APP_THEME
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
                                          SizedBox(
                                            width: 250.w,
                                            child: TextFormField(
                                              controller: yzmaController,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 4,
                                              cursorColor:
                                                  Color(AppColors.APP_THEME),
                                              focusNode: yzmaTextFieldNode,
                                              onEditingComplete: () {
//                  login();
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              style: TextStyle(
                                                color: Color(AppColors.BLACK),
                                                fontSize: 28.sp,
                                              ),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 10.w,
                                                          top: 40.h),
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                  hintText: '请输入验证码',
                                                  hintStyle: TextStyle(
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
                                      margin: EdgeInsets.only(top: 40.w),
                                      child: Row(
                                        children: <Widget>[
                                          //APP_THEME_LIGHT
                                          Container(
                                            height: 40.w,
                                            width: 0.5,
                                            color: Color(AppColors.APP_THEME_LIGHT),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 21.w),
                                            child: TimerCountDownWidget(
                                              phone: phoneController.text,
                                              onTimerFinish: () {
                                                debugPrint('倒计时结束--------');
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
                                    child: TextField(
                                      controller: passController,
                                      keyboardType: TextInputType.url,
                                      cursorColor: Color(AppColors.APP_THEME),
                                      focusNode: passTextFieldNode,
                                      onEditingComplete: () {
//                  login();
                                      },
                                      textInputAction: TextInputAction.done,
                                      obscureText:
                                          _onSeeIndex == 0 ? true : false,
                                      style: TextStyle(
                                        color: Color(AppColors.BLACK),
                                        fontSize: 28.sp,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 10.w, top: 40.h),
                                          border: InputBorder.none,
                                          hintText: '请输入密码',
                                          hintStyle: TextStyle(
                                              color:
                                                  Color(AppColors.TEXT_HINT))),
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
                                                right: 20.w, top: 28.h),
                                            width: 60.w,
                                            alignment: Alignment.centerRight,
                                            child: Image.asset(
                                              _onSeeIndex == 0
                                                  ? AppAssets.loginUnseeIcon
                                                  : AppAssets.loginSeeIcon,
                                              width: 40.w,
                                              height: 40.w,
                                              fit: BoxFit.fill,
                                            )),
                                      )),
                                ],
                              ),
                            ),
                            Divider(
                              color: Color(_onFocus == 1
                                  ? AppColors.APP_THEME
                                  : AppColors.TEXT_CC),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 100.w),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (!setall) {
                              Fluttertoast.showToast(
                                  msg: "请先同意协议",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 24.sp,
                                  textColor: Color(AppColors.TEXT_WHITE),
                                  backgroundColor: Color(0xFF000000));
                              return;
                            }
                            if (_onChickIndex == 0) {
                              if (phoneController.text == "" ||
                                  passController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "请填写完整用户名密码",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 24.sp,
                                    textColor: Color(AppColors.TEXT_WHITE),
                                    backgroundColor: Color(0xFF000000));
                              } else {
                                FormData formData = FormData.fromMap({
                                  "username": phoneController.text,
                                  "pwd": passController.text,
                                });
                                Request.getInstance().post("/logByPwd",
                                    (data) async {
                                  DataUtils.saveLoginInfo(data).then((value) {
                                    if (!context.mounted) return;
                                    bus.send("updateui", "8");
                                    Navigator.pop(context);
                                  });
                                }, params: formData);
                              }
                            } else {
                              if (phoneController.text == "" ||
                                  yzmaController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "请填写完整信息",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 24.sp,
                                    textColor: Color(AppColors.TEXT_WHITE),
                                    backgroundColor: Color(0xFF000000));
                              } else {
                                FormData formData = FormData.fromMap({
                                  "username": phoneController.text,
                                  "code": yzmaController.text,
                                });
                                Request.getInstance().post("/log",
                                    (data) async {
                                  SharedPreferences sp =
                                      await SharedPreferences.getInstance();
                                  await sp.setString(
                                      "phone", phoneController.text);
                                  DataUtils.saveLoginInfo(data).then((value) {
                                    if (!context.mounted) return;
                                    bus.send("updateui", "8");
                                    Navigator.pop(context);
                                  });
                                }, params: formData);
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 85.w, right: 85.w),
                            height: 88.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(AppColors.APP_THEME)),
                              color: Color(AppColors.APP_THEME),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28.0)),
                            ),
                            child: Center(
                              child: Text(
                                '登录',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 28.w),
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
                                    color: Color(AppColors.APP_THEME),
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
                        margin: EdgeInsets.only(top: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    setall = !setall;
                                  });
                                },
                                child: SizedBox(
                                  height: 30.w,
                                  width: 30.w,
                                  child: Image.asset(
                                    setall
                                        ? AppAssets.deleInIcon
                                        : AppAssets.deleUnIcon,
                                    width: 30.w,
                                    height: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(left: 11.w),
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: "注册/登录即代表同意",
                                  style: TextStyle(
                                      color: Color(AppColors.TEXT_HINT),
                                      fontSize: 22.sp),
                                  children: [
                                    TextSpan(
                                      text: '《用户协议》',
                                      style: TextStyle(
                                          color: Color(AppColors.BLACK),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22.sp),
                                      recognizer: _tapGestureRecognizer
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
                                        text: '及',
                                        style: TextStyle(
                                            color: Color(AppColors.TEXT_HINT),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22.sp)),
                                    TextSpan(
                                      text: '《隐私政策》',
                                      style: TextStyle(
                                          color: Color(AppColors.BLACK),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22.sp),
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
