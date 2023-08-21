import 'dart:io';
import 'dart:ui';

import 'package:bct_flutter/page/home_page.dart';
import 'package:bct_flutter/page/loading_page.dart';
import 'package:bct_flutter/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

Future<void> main() async {
  await FlutterDownloader.initialize(
    //表示是否在控制台显示调试信息
    debug: false,
  );

  runApp(widgetForRoute(window.defaultRouteName));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  fluwx.registerWxApi(
      appId: "wxd92d9077ee8812ee", universalLink: "https://www.21132.com.cn");

}
Widget widgetForRoute(String route) {
  switch (route) {
    case '/':
      return new MyApp();
    case 'MainPage':
      return new MyApp();
    default:
      return Center(
        child: Text('Unknown    route1 : $route',
            textDirection: TextDirection.ltr),
      );
  }
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '神农百草',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/MainPage': (ctx) => HomePage(),
      },
      home: SplashPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // 指定本地化的字符串和一些其他的值
        GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
      ],
    );
  }
}
