import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/request.dart';
import 'package:bct_flutter/page/enterprise_zone_view.dart';
import 'package:bct_flutter/page/login_page.dart';
import 'package:bct_flutter/page/widget/choose_dialog_template.dart';
import 'package:bct_flutter/page/widget/down_dialog.dart';
import 'package:bct_flutter/page/widget/xieyi_dialog.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart'
    as flutter_downloader;
import 'academic_information_view.dart';
import 'home_view.dart';
import 'MyView.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomeShopPageState createState() => _HomeShopPageState();
}

class _HomeShopPageState extends State<HomePage> {
  List<Widget> _eachView;
  int _index = 0;

  var userData;
  var getflage = false;
  ReceivePort _port = ReceivePort();

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void initState() {
    init().then((value) {
      if (value) {
        showSplashAd();
      }
    });
    setAdEvent();

    checkPermission(context);
    WidgetsFlutterBinding.ensureInitialized();
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      return;
    }
    // FlutterDownloader.initialize();

    // Future.delayed(Duration.zero, () {
    //   _goWebView();
    // });
    _eachView = List();
    _eachView..add(HomeView());
    _eachView..add(AcademicInformationView());
    _eachView..add(EnterpriseZoneView());
    _eachView..add(MyView());

    super.initState();
    DataUtils.getPreserve("firstin").then((value) {
      if (value == "1") {
      } else {
        getflage = true;
        // XieyiDialog(context);
      }
    });

    Future.delayed(Duration.zero, () {
      getVer();
    });
    flutter_downloader.FlutterDownloader.registerCallback(downloadCallback);

    _port.listen((dynamic data) {
      DataUtils.getPreserve("isApp").then((value) {
        if (value == "true") {
          showDialog(
              // 设置点击 dialog 外部不取消 dialog，默认能够取消
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('提示'),
                    // 标题文字样式
                    content: Text('文件下载完成，是否打开？'),
                    // 内容文字样式
                    backgroundColor: CupertinoColors.white,
                    elevation: 8.0,
                    // 投影的阴影高度
                    semanticLabel: 'Label',
                    // 这个用于无障碍下弹出 dialog 的提示
                    shape: Border.all(),
                    // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
                    actions: <Widget>[
                      // 点击取消按钮
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('取消')),
                      // 点击打开按钮
                      FlatButton(
                          onPressed: () async {
//                        print("安装id" + data.toString());
                            Navigator.pop(context);
                            var _localPath =
                                (await DataUtils().findLocalPath(context)) +
                                    '/Download1/';
                            String _apkFilePath = _localPath + "神农百草.apk";

                            if (_apkFilePath.isEmpty) {
                              print('make sure the apk file is set');
                              return;
                            }

                            InstallPlugin.installApk(
                                    _apkFilePath,)
                                .then((result) {
                              print('install apk $result');
                            }).catchError((error) {
                              print('install apk error: $error');
                            });
                            // 打开文件
//                     DataUtils()
//                         .openDownloadedFile(data.toString())
//                         .then((success) {
// //                          print(success.toString());
//                       if (!success) {
// //                          Scaffold.of(context).showSnackBar(SnackBar(
// //                              content: Text('安装包有问题打开不了')));
//                       }
//                     });
                          },
                          child: Text('打开')),
                    ],
                  ));
        }
      });
    });
  }

  Future<bool> checkPermission(context) async {
    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.unknown);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.unknown]);
        if (permissions[PermissionGroup.unknown] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);

    try {
//将Scaffold 作为WillPopScope的子控件
      return WillPopScope(
          child: Scaffold(

              //融合底部工具栏
              bottomNavigationBar: BottomAppBar(
                //底部工具栏
                color: Colors.white,

                shape: CircularNotchedRectangle(), //圆形缺口

                child: Container(
                  // margin: EdgeInsets.only(left: ScreenUtil().setWidth(70) ,right: ScreenUtil().setWidth(50) ),
                  height: ScreenUtil().setWidth(98),
                  child: SafeArea(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _index = 0;
                            });
                          },
                          child: Container(
                            // color: Colors.white,

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: CachedNetworkImage(
                                    width: ScreenUtil().setWidth(48),
                                    height: ScreenUtil().setWidth(48),
                                    imageUrl: _index == 0
                                        ? "http://snbc.zglcwl.com/Public/fontImages/tab_home_n.png"
                                        : "http://snbc.zglcwl.com/Public/fontImages/tab_home_h.png",
                                  ),
                                ),
                                Text("在线课程",
                                    style: TextStyle(
                                        color: Color(_index == 0
                                            ? AppColors.APP_ThEME
                                            : AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(20),
                                        decoration: TextDecoration.none))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _index = 1;
                            });
                          },
                          child: Container(
                            // color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: CachedNetworkImage(
                                    width: ScreenUtil().setWidth(48),
                                    height: ScreenUtil().setWidth(48),
                                    imageUrl: _index == 1
                                        ? "http://snbc.zglcwl.com/Public/fontImages/tab_msg_n.png"
                                        : "http://snbc.zglcwl.com/Public/fontImages/tab_msg_h.png",
                                  ),
                                ),
                                Text("学术资料",
                                    style: TextStyle(
                                        color: Color(_index == 1
                                            ? AppColors.APP_ThEME
                                            : AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(20),
                                        decoration: TextDecoration.none))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _index = 2;
                            });
                          },
                          child: Container(
                            // color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: CachedNetworkImage(
                                    width: ScreenUtil().setWidth(48),
                                    height: ScreenUtil().setWidth(48),
                                    imageUrl: _index == 2
                                        ? "http://snbc.zglcwl.com/Public/fontImages/tab_qiye_h.png"
                                        : "http://snbc.zglcwl.com/Public/fontImages/tab_qiye_n.png",
                                  ),
                                ),
                                Text("企业专区",
                                    style: TextStyle(
                                        color: Color(_index == 2
                                            ? AppColors.APP_ThEME
                                            : AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(20),
                                        decoration: TextDecoration.none))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            DataUtils.isLogin().then((value) {
                              if (value) {
                                setState(() {
                                  _index = 3;
                                });
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              }
                            });
                          },
                          child: Container(
                            // color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: CachedNetworkImage(
                                    width: ScreenUtil().setWidth(48),
                                    height: ScreenUtil().setWidth(48),
                                    imageUrl: _index == 3
                                        ? "http://snbc.zglcwl.com/Public/fontImages/tab_my_n.png"
                                        : "http://snbc.zglcwl.com/Public/fontImages/tab_my_h.png",
                                  ),
                                ),
                                Text("个人中心",
                                    style: TextStyle(
                                        color: Color(_index == 3
                                            ? AppColors.APP_ThEME
                                            : AppColors.TEXT_HINT),
                                        fontSize: ScreenUtil().setSp(20),
                                        decoration: TextDecoration.none))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: IndexedStack(
                    index: _index,
                    children: <Widget>[
                      _eachView[0],
                      _eachView[1],
                      _eachView[2],
                      _eachView[3]
                    ],
                  )),


                ],
              )),
          onWillPop: () {
            ChooseDialogTemplate(
                context: context,
                title: null,
                contentWidget: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        '是否退出神农百草？',
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
                  exit(0);
                });
          });
    } catch (e, stack) {
      // 有异常时则弹出错误提示
      Fluttertoast.showToast(
          msg: "错误日志" + e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: ScreenUtil().setSp(24),
          textColor: Color(AppColors.TEXT_WIT),
          backgroundColor: Color(0xFF000000));
    }
  }

  bool _returnBool(var _listData, var temp) {
    for (int i = 0; i < _listData.length; i++) {
      if (_listData[i]["id"].toString() == temp.toString()) {
        return false;
      }
    }
    return true;
  }

  var _version;

  Future<void> getVer() async {
    var _localPath = (await DataUtils().findLocalPath(context)) + '/Download1/';
    String _apkFilePath = _localPath + "神农百草.apk";
    File pdf = File(_apkFilePath);
    var exist = await pdf.exists();
    if (exist) {
      pdf.delete();
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.buildNumber;

    Request.getInstance().post("/updata", (data) async {
      final result = json.decode(data);

      print("_version===$_version");
      print(result['version']);
      print(result['download']);
      if (int.parse(_version) < result['version']) {
        DataUtils.setPreserve("isApp", true);
        final savedDir = Directory(_localPath);
// 判断下载路径是否存在
        bool hasExisted = await savedDir.exists();
// 不存在就新建路径
        if (!hasExisted) {
          savedDir.create();
        }
        if (Platform.isIOS) {
        } else {
          DownDialog(context, result['download'], _localPath,
              result['version'].toString(), "有新版本！");
        }
      }
    });
  }

  //  ProgressDialog pr;
  // 根据 downloadUrl 和 savePath 下载文件
  static downloadCallback(id, status, progress) {
    // 打印输出下载信息
//    print('下载 ($id) is in status ($status) and process ($progress)');

//      pr.show();
//      if (!pr.isShowing()) {
//        pr.show();
//      }
    if (status == flutter_downloader.DownloadTaskStatus.running) {
//        pr.update(progress: progress.toDouble(), message: "下载中，请稍后…");
    }
    if (status == flutter_downloader.DownloadTaskStatus.failed) {
      DataUtils.ShowTos("下载异常，请稍后重试");
//        if (pr.isShowing()) {
//          pr.hide();
//        }
    }
    if (status == flutter_downloader.DownloadTaskStatus.complete) {
      SendPort send =
          IsolateNameServer.lookupPortByName('downloader_send_port');
      send.send(id);
    }
    ;
  }

// _goWebView() {
//   Map<String, String> header = Map();
//   header["message"] = "";
//   EvenInfo("getAcivityResult", mapInfo: header).then((e) {
//     setState(() {
//       if (e.toString() == "false") {
//         DataUtils.ShowTos("为了更好服务您请手动打开通知权限");
//       }
//     });
//   });
// }

// 结果信息
  String _result = '';
  String _adEvent = '';

  /// 初始化广告 SDK
  Future<bool> init() async {
    try {
      bool result = await FlutterPangleAds.initAd(
        "5408517",
        directDownloadNetworkType: [
          NetworkType.kNetworkStateMobile,
          NetworkType.kNetworkStateWifi,
        ],
      );
      _result = "广告SDK 初始化${result ? '成功' : '失败'}";
      print("=======$_result");
      // 打开个性化广告推荐
      // FlutterPangleAds.setUserExtData(personalAdsType: '1');

      setState(() {});
      return result;
    } on PlatformException catch (e) {
      _result =
          "广告SDK 初始化失败 code:${e.code} msg:${e.message} details:${e.details}";
      print("=======$_result");
    }
    setState(() {});
    return false;
  }

  /// 设置广告监听
  Future<void> setAdEvent() async {
    setState(() {
      _adEvent = '设置成功';
    });
    FlutterPangleAds.onEventListener((event) {
      _adEvent = 'adId:${event.adId} action:${event.action}';
      if (event is AdErrorEvent) {
        // 错误事件
        _adEvent += ' errCode:${event.errCode} errMsg:${event.errMsg}';
      } else if (event is AdRewardEvent) {
        // 激励事件
        _adEvent +=
            ' rewardType:${event.rewardType} rewardVerify:${event.rewardVerify} rewardAmount:${event.rewardAmount} rewardName:${event.rewardName} errCode:${event.errCode} errMsg:${event.errMsg} customData:${event.customData} userId:${event.userId}';
      }
      // 测试关闭 Banner（会员场景）
      // if (event.action == AdEventAction.onAdClosed &&
      //     event.adId == AdsConfig.bannerId02) {
      //   _adEvent += '仅会员可以关闭广告';
      // }
      print('onEventListener:=====================$_adEvent');
      setState(() {});
    });
  }

  /// 展示开屏广告
  /// [logo] 展示如果传递则展示logo，不传递不展示
  Future<void> showSplashAd([String logo]) async {
    try {
      bool result = await FlutterPangleAds.showSplashAd(
        "888363778",
        logo: logo,
        timeout: 3.5,
      );
      _result = "展示开屏广告${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result = "展示开屏广告失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    print(_result);
  }
}
