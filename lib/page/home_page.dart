import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/request.dart';
import 'package:bct_flutter/page/enterprise_zone_view.dart';
import 'package:bct_flutter/page/login_page.dart';
import 'package:bct_flutter/page/widget/choose_dialog_template.dart';
import 'package:bct_flutter/page/widget/down_dialog.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart'
    as flutter_downloader;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'MyView.dart';
import 'academic_information_view.dart';
import 'home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeShopPageState();
}

class _HomeShopPageState extends State<HomePage> {
  List<Widget> _eachView = [];
  int _index = 0;

  dynamic userData;
  bool getflage = false;
  final ReceivePort _port = ReceivePort();

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void initState() {
    Permission.unknown.request();
    WidgetsFlutterBinding.ensureInitialized();
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      return;
    }
    _eachView = <Widget>[];
    _eachView.add(HomeView());
    _eachView.add(AcademicInformationView());
    _eachView.add(EnterpriseZoneView());
    _eachView.add(MyView());

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
        if (!mounted) return;
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
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('取消')),
                      // 点击打开按钮
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            var localPath =
                                '${await DataUtils().findLocalPath(context)}/Download1/';
                            String apkFilePath = "$localPath神农百草.apk";

                            if (apkFilePath.isEmpty) {
                              debugPrint('make sure the apk file is set');
                              return;
                            }

                            // 显示APK文件位置信息
                            DataUtils.ShowTos('APK文件已下载至: $apkFilePath');
                            debugPrint('APK file downloaded to: $apkFilePath');
                            // 打开文件
                          },
                          child: Text('打开')),
                    ],
                  ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), minTextAdapt: true);

    try {
//将Scaffold 作为WillPopScope的子控件
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          chooseDialogTemplate(
              context: context,
              title: "退出确认",
              contentWidget: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
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
              cancelCallback: () {},
              confirmCallBack: () {
                exit(0);
              });
        },
        child: Scaffold(

            //融合底部工具栏
            bottomNavigationBar: BottomAppBar(
              //底部工具栏
              color: Colors.white,

              shape: CircularNotchedRectangle(), //圆形缺口

              child: SizedBox(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              _index == 0
                                  ? AppAssets.tabHomeSelected
                                  : AppAssets.tabHomeUnselected,
                              width: ScreenUtil().setWidth(48),
                              height: ScreenUtil().setWidth(48),
                            ),
                            Text("在线课程",
                                style: TextStyle(
                                    color: Color(_index == 0
                                        ? AppColors.APP_THEME
                                        : AppColors.TEXT_HINT),
                                    fontSize: ScreenUtil().setSp(20),
                                    decoration: TextDecoration.none))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _index = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              _index == 1
                                  ? AppAssets.tabMsgSelected
                                  : AppAssets.tabMsgUnselected,
                              width: ScreenUtil().setWidth(48),
                              height: ScreenUtil().setWidth(48),
                            ),
                            Text("学术资料",
                                style: TextStyle(
                                    color: Color(_index == 1
                                        ? AppColors.APP_THEME
                                        : AppColors.TEXT_HINT),
                                    fontSize: ScreenUtil().setSp(20),
                                    decoration: TextDecoration.none))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _index = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              _index == 2
                                  ? AppAssets.tabEnterpriseSelected
                                  : AppAssets.tabEnterpriseUnselected,
                              width: ScreenUtil().setWidth(48),
                              height: ScreenUtil().setWidth(48),
                            ),
                            Text("企业专区",
                                style: TextStyle(
                                    color: Color(_index == 2
                                        ? AppColors.APP_THEME
                                        : AppColors.TEXT_HINT),
                                    fontSize: ScreenUtil().setSp(20),
                                    decoration: TextDecoration.none))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Capture navigator before the async gap
                          final navigator = Navigator.of(context);
                          final value = await DataUtils.isLogin();
                          if (!mounted) return;
                          if (value) {
                            setState(() {
                              _index = 3;
                            });
                          } else {
                            if (!context.mounted) return;
                            navigator.push(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              _index == 3
                                  ? AppAssets.tabMySelected
                                  : AppAssets.tabMyUnselected,
                              width: 24,
                              height: 24,
                            ),
                            Text("个人中心",
                                style: TextStyle(
                                    color: Color(_index == 3
                                        ? AppColors.APP_THEME
                                        : AppColors.TEXT_HINT),
                                    fontSize: ScreenUtil().setSp(20),
                                    decoration: TextDecoration.none))
                          ],
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
      );
    } catch (e) {
      // 有异常时则弹出错误提示
      Fluttertoast.showToast(
          msg: "错误日志$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: ScreenUtil().setSp(24),
          textColor: Color(AppColors.TEXT_WHITE),
          backgroundColor: Color(0xFF000000));
      return const SizedBox.shrink(); // Return a default widget on error
    }
  }

  String _version = "1";

  Future<void> getVer() async {
    var localPath = '${await DataUtils().findLocalPath(context)}/Download1/';
    String apkFilePath = "$localPath神农百草.apk";
    File pdf = File(apkFilePath);
    var exist = await pdf.exists();
    if (exist) {
      pdf.delete();
    }
    // 简化版本获取，不再依赖package_info
    _version = "1"; // 默认版本号

    Request.getInstance().post("/updata", (data) async {
      final result = json.decode(data);
      if (!mounted) return;

      debugPrint("_version===$_version");
      debugPrint("${result['version']}");
      debugPrint("${result['download']}");
      if (int.parse(_version) < result['version']) {
        DataUtils.setPreserve("isApp", "true");
        final savedDir = Directory(localPath);
// 判断下载路径是否存在
        bool hasExisted = await savedDir.exists();
// 不存在就新建路径
        if (!hasExisted) {
          savedDir.create();
        }
        if (Platform.isIOS) {
        } else {
          if (!mounted) return;
          DownDialog(context, result['download'], localPath,
              result['version'].toString(), "有新版本！");
        }
      }
    });
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final flutter_downloader.DownloadTaskStatus taskStatus =
        flutter_downloader.DownloadTaskStatus.values[status];
    if (taskStatus == flutter_downloader.DownloadTaskStatus.running) {
    }
    if (taskStatus == flutter_downloader.DownloadTaskStatus.failed) {
      DataUtils.ShowTos("下载异常，请稍后重试");
    }
    if (taskStatus == flutter_downloader.DownloadTaskStatus.complete) {
      SendPort? send =
          IsolateNameServer.lookupPortByName('downloader_send_port');
      send?.send(id);
    }
  }

}

