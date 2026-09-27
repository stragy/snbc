import 'dart:io';
import 'dart:ui';

import 'package:bct_flutter/page/home_page.dart';
import 'package:bct_flutter/page/splash_page.dart';
import 'package:bct_flutter/utils/screen_util_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      await FlutterDownloader.initialize(debug: false);
      FlutterDownloader.registerCallback(downloadCallback);
    } catch (e) {
      debugPrint("Failed to initialize FlutterDownloader: $e");
    }

    try {
      // TODO: 替换为真实的微信 AppID 和 Universal Link
      await Fluwx().registerApi(
        appId: "您的微信AppID",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://您的universalLink/",
      );
    } catch (e) {
      debugPrint("Failed to register WeChat API: $e");
    }
  }

  // 注意：穿山甲广告 SDK 不在启动时初始化。
  // 合规要求：必须在用户同意《服务协议和隐私政策》后才能初始化并展示广告，
  // 实际初始化与开屏展示见 SplashPage → AdHelper.initAds() / showSplashAd()。

  runApp(const MyApp());

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilHelper.init(
      child: MaterialApp(
        title: '神农百草',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        routes: {'/MainPage': (ctx) => const HomePage()},
        home: const SplashPage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('zh', 'CN')],
      ),
    );
  }
}
