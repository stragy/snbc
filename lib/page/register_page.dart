import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/page/widget/BlankToolBarTool.dart';
import 'package:bct_flutter/page/widget/TimerCountDownWidget.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/EventBus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  final String userid;

  RegisterPage(this.userid);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _agree = 0;
  TextEditingController phoneController = TextEditingController();
  TextEditingController yzmaController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passAginController = TextEditingController();
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  TapGestureRecognizer _tapGestureRecognizer2 = new TapGestureRecognizer();
  var bus = EventBus();

  // 光标跳转的输入框对象
  FocusNode secondTextFieldNode = FocusNode();
  FocusNode passTextFieldNode = FocusNode();
  FocusNode passAginTextFieldNode = FocusNode();
  FocusNode yzmaTextFieldNode = FocusNode();

  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  var _onChickIndex = 0;
  var _onSeeIndex = 0;
  var _onSeeAginIndex = 0;
  var _onFocus = 0;

  // 释放对象使用的资源
  @override
  void dispose() {
    super.dispose();
    blankToolBarModel.removeFocusListeners();
    passTextFieldNode.dispose();
    passAginTextFieldNode.dispose();
    yzmaTextFieldNode.dispose();
    secondTextFieldNode.dispose();
    _tapGestureRecognizer.dispose();
    _tapGestureRecognizer2.dispose();
    phoneController.dispose();
    yzmaController.dispose();
    passController.dispose();
    passAginController.dispose();
  }

  void focusNodeChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Step2.1: 焦点变化时的响应
    blankToolBarModel.outSideCallback = focusNodeChange;
    secondTextFieldNode.addListener(() {
      if (secondTextFieldNode.hasFocus) {
        setState(() {
          _onFocus = 0;
        });
      } else {}
    });
    phoneController.addListener(() {
      setState(() {});
    });
    passTextFieldNode.addListener(() {
      if (passTextFieldNode.hasFocus) {
        setState(() {
          _onFocus = 1;
        });
      } else {}
    });
    passAginTextFieldNode.addListener(() {
      if (passAginTextFieldNode.hasFocus) {
        setState(() {
          _onFocus = 3;
        });
      } else {}
    });
    yzmaTextFieldNode.addListener(() {
      if (yzmaTextFieldNode.hasFocus) {
        setState(() {
          _onFocus = 2;
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            // resizeToAvoidBottomPadding: false, //输入框抵住键盘
            appBar: AppBar(
              elevation: 0,
              //去掉Appbar底部阴影
              leading: IconButton(
                  icon: Image.network(
                    "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
                    width: 11,
                    height: 19,
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: true,
              title: Text(widget.userid == "1" ? '账号注册' : "设置密码"),
              backgroundColor: Color(AppColors.APP_ThEME),
              centerTitle: true,
              brightness: Brightness.dark,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              toolbarOpacity: 1.0,
              bottomOpacity: 1.0,
              primary: true,
            ),
            body: BlankToolBarTool.blankToolBarWidget(context,
                showToolBar: false,
                model: blankToolBarModel,
                body: Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(70),
                      right: ScreenUtil().setWidth(70)),
                  color: Color(AppColors.TEXT_WIT),
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
                                cursorColor: Color(AppColors.APP_ThEME),
                                // 键盘动作按钮，如“下一步”
                                textInputAction: TextInputAction.next,
                                // 键盘动作按钮点击之后执行的代码：

                                //光标切换到指定的输入框
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(secondTextFieldNode);
                                },
                                // 文本样式
                                style: new TextStyle(
                                    color: Color(AppColors.BLACK)),
                                decoration: InputDecoration(
                                    // 输入框边框
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10),
                                        top: ScreenUtil().setWidth(40)),
                                    // 提示文字
                                    hintText: '请输入手机号',
                                    // 提示文本颜色
                                    hintStyle: new TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                        color: Color(AppColors.TEXT_HINT))),
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
                                      right: ScreenUtil().setWidth(20),
                                      top: ScreenUtil().setWidth(28)),
                                  width: ScreenUtil().setWidth(60),
                                  alignment: Alignment.centerRight,
                                  child: Image.network( "http://snbc.zglcwl.com/Public/fontImages/del_login_icon.png",
                                    width: ScreenUtil().setWidth(32),
                                    height: ScreenUtil().setWidth(32),
                                    fit: BoxFit.fill,

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
                        offstage: false,
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
                                      width: ScreenUtil().setWidth(250),
                                      child: TextFormField(
                                        controller: yzmaController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        cursorColor: Color(AppColors.APP_ThEME),
                                        focusNode: yzmaTextFieldNode,
                                        onEditingComplete: () {},
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                          color: Color(AppColors.BLACK),
                                          fontSize: ScreenUtil().setSp(28),
                                        ),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(10),
                                                top:
                                                    ScreenUtil().setHeight(40)),
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '请输入验证码',
                                            hintStyle: new TextStyle(
                                                color: Color(
                                                    AppColors.TEXT_HINT))),
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
                                    Container(
                                      height: ScreenUtil().setWidth(40),
                                      width: 0.5,
                                      color: Color(AppColors.APP_ThEME),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(21)),
                                      child: TimerCountDownWidget(
                                        phone: phoneController.text,
                                        onTimerFinish: () {
                                          print("倒计时结束--------");
                                        },
                                        reg: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Divider(
                        color: Color(_onFocus == 2
                            ? AppColors.APP_ThEME
                            : AppColors.TEXT_CC),
                      ),
                      widget.userid == "1"
                          ? SizedBox()
                          : Offstage(
                              offstage: false,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: new TextField(
                                      controller: passController,
                                      keyboardType: TextInputType.url,
                                      cursorColor: Color(AppColors.APP_ThEME),
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
                                              left: ScreenUtil().setWidth(10),
                                              top: ScreenUtil().setWidth(40)),
                                          border: InputBorder.none,
                                          hintText: '请输入密码',
                                          hintStyle: new TextStyle(
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
                                              right: ScreenUtil().setWidth(20),
                                              top: ScreenUtil().setWidth(28)),
                                          width: ScreenUtil().setWidth(60),
                                          alignment: Alignment.centerRight,
                                          child: Image.network( _onSeeIndex == 0
                                              ? "http://snbc.zglcwl.com/Public/fontImages/login_unsee_icon.png"
                                              : "http://snbc.zglcwl.com/Public/fontImages/login_see_icon.png",
                                            width: ScreenUtil().setWidth(40),
                                            height: ScreenUtil().setWidth(40),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                      widget.userid == "1"
                          ? SizedBox()
                          : new Divider(
                              color: Color(_onFocus == 1
                                  ? AppColors.APP_ThEME
                                  : AppColors.TEXT_CC),
                            ),
                      widget.userid == "1"
                          ? SizedBox()
                          : Offstage(
                              offstage: false,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: new TextField(
                                      controller: passAginController,
                                      keyboardType: TextInputType.url,
                                      cursorColor: Color(AppColors.APP_ThEME),
                                      focusNode: passAginTextFieldNode,
                                      onEditingComplete: () {
//                  login();
                                      },
                                      textInputAction: TextInputAction.done,
                                      obscureText:
                                          _onSeeAginIndex == 0 ? true : false,
                                      style: TextStyle(
                                        color: Color(AppColors.BLACK),
                                        fontSize: ScreenUtil().setSp(28),
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(10),
                                              top: ScreenUtil().setWidth(40)),
                                          border: InputBorder.none,
                                          hintText: '请确认密码',
                                          hintStyle: new TextStyle(
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
                                            if (_onSeeAginIndex == 0) {
                                              _onSeeAginIndex = 1;
                                            } else {
                                              _onSeeAginIndex = 0;
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(20),
                                              top: ScreenUtil().setWidth(28)),
                                          width: ScreenUtil().setWidth(60),
                                          alignment: Alignment.centerRight,
                                          child: Image.network(_onSeeIndex == 0
                                              ? "http://snbc.zglcwl.com/Public/fontImages/login_unsee_icon.png"
                                              : "http://snbc.zglcwl.com/Public/fontImages/login_see_icon.png",
                                            width: ScreenUtil().setWidth(40),
                                            height: ScreenUtil().setWidth(40),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                      widget.userid == "1"
                          ? SizedBox()
                          : new Divider(
                              color: Color(_onFocus == 3
                                  ? AppColors.APP_ThEME
                                  : AppColors.TEXT_CC),
                            ),
                      widget.userid == "1"
                          ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(32)),
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
                                          child: Image.network(setall
                                              ? "http://snbc.zglcwl.com/Public/fontImages/dele_in_icon.png"
                                              : "http://snbc.zglcwl.com/Public/fontImages/dele_un_icon.png",
                                            width: ScreenUtil().setWidth(30),
                                            height: ScreenUtil().setWidth(30),
                                            fit: BoxFit.fill,
                                          ))),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(11)),
                                    alignment: Alignment.center,
                                    child: RichText(
                                      maxLines: 2,
                                      text: TextSpan(
                                        text: "注册/登录即代表同意",
                                        style: TextStyle(
                                            color: Color(AppColors.TEXT_HINT),
                                            fontSize: ScreenUtil().setSp(20)),
                                        children: [
                                          TextSpan(
                                            text: '《用户协议》',
                                            style: TextStyle(
                                                color: Color(AppColors.BLACK),
                                                fontWeight: FontWeight.normal,
                                                fontSize:
                                                    ScreenUtil().setSp(20)),
                                            recognizer: _tapGestureRecognizer
                                              ..onTap = () {
                                                setState(() {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebPage(
                                                                  name: "用户协议",
                                                                  url:
                                                                      "http://snbc.zglcwl.com/Public/html/user.html",
                                                                  isShare:
                                                                      false)));
                                                });
                                              },
                                          ),
                                          TextSpan(
                                              text: '及',
                                              style: TextStyle(
                                                  color: Color(
                                                      AppColors.TEXT_HINT),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize:
                                                      ScreenUtil().setSp(20))),
                                          TextSpan(
                                            text: '《隐私政策》',
                                            style: TextStyle(
                                                color: Color(AppColors.BLACK),
                                                fontWeight: FontWeight.normal,
                                                fontSize:
                                                    ScreenUtil().setSp(20)),
                                            recognizer: _tapGestureRecognizer2
                                              ..onTap = () {
                                                setState(() {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebPage(
                                                                  name: "隐私政策",
                                                                  url:
                                                                      "http://snbc.zglcwl.com/Public/html/agreement.html",
                                                                  isShare:
                                                                      false)));
                                                });
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
                        child: InkWell(
                          onTap: () {
                            if (widget.userid == "1") {
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
                                Request.getInstance().post("/reg",
                                    (data) async {
                                  Fluttertoast.showToast(
                                      msg: "注册成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: ScreenUtil().setSp(24),
                                      textColor: Color(AppColors.TEXT_WIT),
                                      backgroundColor: Color(0xFF000000));
                                  Navigator.pop(context);
                                }, params: formData);
                              }
                            } else {
                              if (phoneController.text == null ||
                                  phoneController.text == "" ||
                                  yzmaController.text == null ||
                                  yzmaController.text == "" ||
                                  passController.text == null ||
                                  passController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "请填写完整信息",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: ScreenUtil().setSp(24),
                                    textColor: Color(AppColors.TEXT_WIT),
                                    backgroundColor: Color(0xFF000000));
                              } else {
                                if (passController.text ==
                                    passAginController.text) {
                                  DataUtils.getUserId().then((value) {
                                    FormData formData = new FormData.fromMap({
                                      "username": phoneController.text,
                                      "pwd": passAginController.text,
                                      "user_id": value,
                                    });
                                    Request.getInstance().post("/setPwd",
                                        (data) async {
                                      Fluttertoast.showToast(
                                          msg: "设置成功",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          fontSize: ScreenUtil().setSp(24),
                                          textColor: Color(AppColors.TEXT_WIT),
                                          backgroundColor: Color(0xFF000000));
                                      Navigator.pop(context);
                                    }, params: formData);
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "密码不一致",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: ScreenUtil().setSp(24),
                                      textColor: Color(AppColors.TEXT_WIT),
                                      backgroundColor: Color(0xFF000000));
                                }
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(0),
                                right: ScreenUtil().setWidth(0)),
                            height: ScreenUtil().setWidth(88),
                            decoration: BoxDecoration(
                              border: new Border.all(
                                  width: 1, color: Color(0xFF0091FF)),
                              color: Color(AppColors.APP_ThEME),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28.0)),
                            ),
                            child: Center(
                              child: Text(
                                widget.userid == "1" ? '注册并登录' : "提交",
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
                    ],
                  ),
                )));
  }

  var setall = false;
}
