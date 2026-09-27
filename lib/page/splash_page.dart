import 'package:bct_flutter/common/ad_helper.dart';
import 'package:bct_flutter/page/widget/xieyi_dialog.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/event_bus.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var bus = EventBus();
  bool _entered = false;

  @override
  void initState() {
    super.initState();

    // isFirst() == true 表示尚未同意过协议（首次安装默认 true）
    DataUtils.isFirst().then((value) async {
      if (!mounted) return;
      if (value) {
        // 未同意协议 → 先弹协议，用户同意后再初始化广告（合规要求）
        xieyiDialog(context);
      } else {
        await _enterHome();
      }
    });

    // 用户在协议弹窗中点击「同意」后会 send("goHome")
    bus.on("goHome", _onAgree);
  }

  Future<void> _onAgree(dynamic arg) async => _enterHome();

  /// 进入首页：先初始化广告 SDK（用户已同意协议）→ 展示开屏 → 跳转首页
  Future<void> _enterHome() async {
    if (_entered) return;
    _entered = true;
    if (!mounted) return;
    // 合规：仅在用户同意协议之后初始化 SDK
    await AdHelper.initAds();
    // 开屏广告，无填充时静默跳过
    await AdHelper.showSplashAd();
    if (!mounted) return;
    // 用 pushReplacement：避免返回键回到开屏页后卡死
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    bus.off("goHome", _onAgree);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Image.asset(
        "images/loading.jpg",
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
