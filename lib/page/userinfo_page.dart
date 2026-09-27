import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/choose_dialog_template.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/event_bus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:image_picker/image_picker.dart';

import 'login_page.dart';

typedef _DateClickCallBack = void Function(
    dynamic selectDateStr, dynamic selectData);
typedef _StringClickCallBack = void Function(
    int selectIndex, Object? selectStr);

const double _kPickerHeight = 216.0;

const Color _kTitleColor = Color(0xFF787878);
const double _kTextFontSize = 17.0;

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  dynamic userinfo;
  String? _imgPath;
  var bus = EventBus();
  String? birth;
  String? sex;
  String? nickName;
  bool isClose = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() {
    DataUtils.getUserId().then((value) {
      FormData formData = FormData.fromMap({
        "user_id": value,
      });
      Request.getInstance().post("/personal", (data) async {
        setState(() {
          userinfo = data;
          birth = userinfo['birth'];
          sex = userinfo['sex'] == "1" ? "男" : "女";
          nickName = userinfo['nickname'];
        });
      }, params: formData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        //后面放置图标
        actions: <Widget>[
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 15),
              child: Text(
                "保存",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            onTap: () {
              isClose = true;
              save();
            },
          )
        ],

        automaticallyImplyLeading: true,
        title: Text('个人信息'),
        backgroundColor: Color(AppColors.APP_THEME),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        primary: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(12), left: 15),
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: <Widget>[
                    Flex(direction: Axis.horizontal, children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '头像',
                              style: TextStyle(
                                fontFamily: "familyFontStyle",
                                color: Color(AppColors.BLACK),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () {
                              _openModalBottomSheet();
                            },
                            child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(11),
                                    right: ScreenUtil().setWidth(11)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(28)),
                                        child: userinfo == null ||
                                                userinfo['head'] == null
                                            ? Image.asset(
                                                "images/head_dis.png",
                                                width:
                                                    ScreenUtil().setWidth(70),
                                                height:
                                                    ScreenUtil().setWidth(70),
                                              )
                                            : Image.network(
                                                userinfo['head'],
                                                width:
                                                    ScreenUtil().setWidth(80),
                                                height:
                                                    ScreenUtil().setWidth(80),
                                                fit: BoxFit.fill,
                                                //广告图片地址
//                                            placeholder: (context, url) => _buildSplashBg(),
//                                            errorWidget: (context, url, error) => _buildSplashBg(),
                                              ),
                                      ),
                                    ),
                                    Image.network(
                                      "http://snbc.zglcwl.com/Public/fontImages/button_next.png",
                                      width: 16,
                                      height: 16,
                                    )
                                  ],
                                ))),
                      ),
                    ]),
                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Divider(
                height: 0.5,
              )),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(32), left: 15),
            child: Column(
              children: <Widget>[
                Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '姓名',
                          style: TextStyle(
                            fontFamily: "familyFontStyle",
                            color: Color(AppColors.BLACK),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                        onTap: () {
                          showNameAlertDialog(context, nickName);
                        },
                        child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(11),
                                right: ScreenUtil().setWidth(11)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                    nickName ?? "",
                                    style: TextStyle(
                                        color: Color(AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(28),
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                                Image.network(
                                  "http://snbc.zglcwl.com/Public/fontImages/button_next.png",
                                  width: 16,
                                  height: 16,
                                )
                              ],
                            ))),
                  ),
                ]),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Divider(
                height: 0.5,
              )),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(32), left: 15),
            child: Column(
              children: <Widget>[
                Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '性别',
                          style: TextStyle(
                            fontFamily: "familyFontStyle",
                            color: Color(AppColors.BLACK),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          List<String> data = <String>["女", "男"];
                          showStringPicker(context, data: data,
                              clickCallBack: (int position, var time) {
                            sex = data[position];
                            setState(() {});
                          });
                        },
                        child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(11),
                                right: ScreenUtil().setWidth(11)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                    sex ?? "",
                                    style: TextStyle(
                                        color: Color(AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(28),
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                                Image.network(
                                  "http://snbc.zglcwl.com/Public/fontImages/button_next.png",
                                  width: 16,
                                  height: 16,
                                )
                              ],
                            )),
                      )),
                ]),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Divider(
                height: 0.5,
              )),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(32), left: 15),
            child: Column(
              children: <Widget>[
                Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '出生日期',
                          style: TextStyle(
                            fontFamily: "familyFontStyle",
                            color: Color(AppColors.BLACK),
                            fontSize: ScreenUtil().setSp(28),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          showDatePickerDialog(context,
                              clickCallBack: (var str, var time) {
                            birth = str;
                            setState(() {});
                          });
                        },
                        child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(11),
                                right: ScreenUtil().setWidth(11)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                    birth ?? "",
                                    style: TextStyle(
                                        color: Color(AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(28),
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                                Image.network(
                                  "http://snbc.zglcwl.com/Public/fontImages/button_next.png",
                                  width: 16,
                                  height: 16,
                                )
                              ],
                            )),
                      )),
                ]),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(32)),
              child: Divider(
                height: 0.5,
              )),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(50),
                  bottom: 20,
                  top: 80,
                  right: ScreenUtil().setWidth(50)),
              height: ScreenUtil().setWidth(88),
              decoration: BoxDecoration(
                color: Color(AppColors.APP_THEME),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  "注销账号",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              chooseDialogTemplate(
                  context: context,
                  title: null,
                  contentWidget: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '是否注销账号？',
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
                    logOff();
                    Navigator.pop(context);
                  });
            },
          ),
        ],
      ),
    );
  }

  void logOff() {
    DataUtils.getUserId().then((value) {
      FormData formData = FormData.fromMap({
        "user_id": value,
      });
      Request.getInstance().post("/logOff", (data) async {
        DataUtils.clearLoginInfo();
        Future.delayed(const Duration(seconds: 2), () {
          bus.send("updateui", "8");
        });
        _login();
      }, params: formData);
    });
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

  static Future<void> showStringPicker<T>(
    BuildContext context, {
    required List<T> data,
    String? title,
    int? normalIndex,
    required _StringClickCallBack clickCallBack,
  }) async {
    final int initialIndex =
        (normalIndex != null && normalIndex >= 0 && normalIndex < data.length)
            ? normalIndex
            : 0;
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: _kPickerHeight + 56,
            child: Column(
              children: [
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(title ?? '请选择',
                      style: TextStyle(
                          color: _kTitleColor, fontSize: _kTextFontSize)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (c, i) {
                      final selected = i == initialIndex;
                      return ListTile(
                        title: Text(
                          '${data[i]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selected ? Colors.black : Colors.black87),
                        ),
                        onTap: () => Navigator.pop(ctx, i),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selectedIndex != null) {
      clickCallBack(selectedIndex, data[selectedIndex]);
    }
  }

  Future _openModalBottomSheet() async {
    // final option = await showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //         height: 200.0,
    //         child: Column(
    //           children: <Widget>[
    //             ListTile(
    //               title: Text('拍照', textAlign: TextAlign.center),
    //               onTap: () {
    //                 _takePhoto();
    //                 Navigator.pop(context, '拍照');
    //               },
    //             ),
    //             ListTile(
    //               title: Text('从相册选择', textAlign: TextAlign.center),
    //               onTap: () {
    //                 _openGallery();
    //                 Navigator.pop(context, '从相册选择');
    //               },
    //             ),
    //             ListTile(
    //               title: Text('取消', textAlign: TextAlign.center),
    //               onTap: () {
    //                 Navigator.pop(context, '取消');
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     });
    //
    // print(option);
  }

  void showNameAlertDialog(BuildContext context, name) {
    TextEditingController nameController = TextEditingController(); //昵称
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '修改昵称',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: 100,
              height: 50,
              child: TextField(
                controller: nameController,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入昵称',
                  hintStyle: TextStyle(
                      fontSize: 15, color: Color(AppColors.TEXT_HINT)),
                ),
                style:
                    TextStyle(fontSize: 15, color: Color(AppColors.TEXT_BLACK)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Navigator.pop(context);
                      nickName = nameController.text;
                      setState(() {});
                    }
                  },
                  child: Text('确认')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text('取消')),
            ],
          );
        });
  }

  // /*拍照*/
  // _takePhoto() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.camera);
  //   if (image == null) {
  //     return;
  //   }
  //   DataUtils.imageCompressToFile(image).then((imageurl) {
  //     FlutterImageCompress.compressWithFile(imageurl.absolute.path, quality: 20)
  //         .then((imageBytes) {
  //       _imgPath = base64Encode(imageBytes);
  //     });
  //   });
  //   save();
  // }
  //
  // /*相册*/
  // _openGallery() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (image == null) {
  //     return;
  //   }
  //   DataUtils.imageCompressToFile(image).then((imageurl) {
  //     FlutterImageCompress.compressWithFile(imageurl.absolute.path, quality: 20)
  //         .then((imageBytes) {
  //       _imgPath = base64Encode(imageBytes);
  //     });
  //   });
  //   save();
  // }

  void save() {
    debugPrint('$_imgPath');
    DataUtils.getUserId().then((value) {
      FormData formData = FormData.fromMap({
        "user_id": value,
        "head": _imgPath,
        "nickname": nickName,
        "sex": sex == "男" ? "1" : "0",
        "birth": birth,
      });
      Request.getInstance().post("/personalModify", (data) async {
        setState(() {
          bus.send("updateui", "8");
          if (isClose) {
            Navigator.pop(context, "refresh");
          } else {
            getUserInfo();
          }
        });
      }, params: formData);
    });
  }

  // 日期/时间选择（底部弹出，使用 CupertinoDatePicker）
  static Future<void> showDatePickerDialog(
    BuildContext context, {
    DateType? dateType,
    String? title,
    DateTime? maxValue,
    DateTime? minValue,
    DateTime? value,
    required _DateClickCallBack clickCallBack,
  }) async {
    DateTime temp = value ?? DateTime.now();
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: _kPickerHeight + 56,
            child: Column(
              children: [
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(title ?? '请选择',
                      style: TextStyle(
                          color: _kTitleColor, fontSize: _kTextFontSize)),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: (dateType == DateType.ym)
                        ? CupertinoDatePickerMode.date
                        : (dateType == DateType.ymdHm ||
                                dateType == DateType.ymdApHm)
                            ? CupertinoDatePickerMode.dateAndTime
                            : CupertinoDatePickerMode.date,
                    initialDateTime: temp,
                    minimumDate: minValue,
                    maximumDate: maxValue,
                    use24hFormat: true,
                    onDateTimeChanged: (dt) => temp = dt,
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('取消')),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, temp),
                          child: const Text('确定')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (picked == null) return;
    final d = picked;
    String timeStr;
    switch (dateType) {
      case DateType.ym:
        timeStr = '${d.year}-${d.month}-';
        break;
      case DateType.ymdHm:
        timeStr = '${d.year}-${d.month}-${d.day}日${d.hour}时${d.minute}分';
        break;
      case DateType.ymdApHm:
        timeStr = '${d.year}-${d.month}-${d.day}';
        break;
      case DateType.ymd:
      default:
        timeStr = '${d.year}-${d.month}-${d.day}';
        break;
    }
    clickCallBack(timeStr, d);
  }
}

enum DateType {
  ymd, // y,m,d
  ym, // y,m
  ymdHm, //y,m,d,hh,mm
  ymdApHm, //y,m,d,ap,hh,mm
}
