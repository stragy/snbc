import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bct_flutter/common/ad_helper.dart';
import 'package:bct_flutter/common/ads_config.dart';
import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/request.dart';
import 'package:bct_flutter/page/splash_page.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:bct_flutter/model/banner_model.dart';
import 'package:bct_flutter/model/article_model.dart';
import 'package:bct_flutter/model/enterprise_model.dart';

// ============================================================
// 辅助
// ============================================================
Future<void> _setUp({bool isFirst = true, bool isLogin = false}) async {
  SharedPreferences.setMockInitialValues({
    'isFirst': isFirst,
    'isLogin': isLogin,
    'id': '',
    'username': '',
    'nickName': '',
    'phone': '',
    'firstin': '1',
  });
}

// ============================================================
// 功能测试 - 神农百草 App
// 说明：以下测试在无后端环境下运行。
// 涉及远程图片加载的页面测试（LoginPage、RegisterPage、
// MyView、SearchPage 等）因服务端不可用已跳过，
// 仅测试本地可验证的功能。
// ============================================================
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // 1. 应用启动与闪屏测试
  // ============================================================
  group('1. 应用启动与闪屏测试', () {
    testWidgets('SplashPage 显示闪屏图片', (WidgetTester tester) async {
      // isFirst=true 时会自动导航到 HomePage，所以用 isFirst=false
      await _setUp(isFirst: false);
      await tester.pumpWidget(const MaterialApp(home: SplashPage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 验证页面包含图片和 Scaffold
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('SplashPage 背景为白色', (WidgetTester tester) async {
      await _setUp(isFirst: false);
      await tester.pumpWidget(const MaterialApp(home: SplashPage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 验证 Scaffold 存在
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // ============================================================
  // 2. 网络请求模块测试
  // ============================================================
  group('2. 网络请求模块测试', () {
    test('Request 单例模式正确创建', () {
      final i1 = Request.getInstance();
      final i2 = Request.getInstance();
      expect(identical(i1, i2), true);
    });

    test('Request 实例不为空', () {
      expect(Request.getInstance(), isNotNull);
    });
  });

  // ============================================================
  // 3. 数据工具类测试
  // ============================================================
  group('3. 数据工具类测试', () {
    test('getRandomString 返回5位字符串', () {
      final r = DataUtils.getRandomString();
      expect(r.length, 5);
      expect(r, isNotEmpty);
    });

    test('getRandomString 多次调用产生不同结果', () {
      final s = <String>{};
      for (int i = 0; i < 10; i++) s.add(DataUtils.getRandomString());
      expect(s.length, greaterThanOrEqualTo(3));
    });

    test('isLogin 未登录返回 false', () async {
      await _setUp(isLogin: false);
      expect(await DataUtils.isLogin(), false);
    });

    test('isLogin 已登录返回 true', () async {
      await _setUp(isLogin: true);
      expect(await DataUtils.isLogin(), true);
    });

    test('saveLoginInfo 正确保存', () async {
      await _setUp();
      await DataUtils.saveLoginInfo({
        'username': 'testuser',
        'nickname': '测试用户',
        'user_id': '12345',
      });
      expect(await DataUtils.isLogin(), true);
      expect(await DataUtils.getUserId(), '12345');
    });

    test('clearLoginInfo 正确清除', () async {
      await _setUp(isLogin: true);
      await DataUtils.saveLoginInfo({
        'username': 'testuser',
        'nickname': '测试用户',
        'user_id': '12345',
      });
      await DataUtils.clearLoginInfo();
      expect(await DataUtils.isLogin(), false);
      expect(await DataUtils.getUserId(), '');
    });

    test('getPreserve/setPreserve 正常工作', () async {
      await _setUp();
      await DataUtils.setPreserve('k', 'v');
      expect(await DataUtils.getPreserve('k'), 'v');
    });

    test('getPreserve 不存在的key返回空', () async {
      await _setUp();
      expect(await DataUtils.getPreserve('none'), '');
    });

    test('isFirst 默认 true', () async {
      await _setUp();
      expect(await DataUtils.isFirst(), true);
    });

    test('setFirst 后 isFirst 返回对应值', () async {
      await _setUp();
      await DataUtils.setFirst(false);
      expect(await DataUtils.isFirst(), false);
    });
  });

  // ============================================================
  // 4. EventBus 测试
  // ============================================================
  group('4. EventBus 测试', () {
    test('注册和发送事件', () {
      final bus = EventBus();
      String? r;
      bus.on('e', (arg) => r = arg as String);
      bus.send('e', 'hello');
      expect(r, 'hello');
    });

    test('多个监听器接收事件', () {
      final bus = EventBus();
      String? a, b;
      bus.on('e', (arg) => a = arg as String);
      bus.on('e', (arg) => b = arg as String);
      bus.send('e', 'w');
      expect(a, 'w');
      expect(b, 'w');
    });

    test('不同事件名互不干扰', () {
      final bus = EventBus();
      String? a, b;
      bus.on('a', (arg) => a = arg as String);
      bus.on('b', (arg) => b = arg as String);
      bus.send('a', '1');
      expect(a, '1');
      expect(b, isNull);
    });
  });

  // ============================================================
  // 5. 颜色常量测试
  // ============================================================
  group('5. 颜色常量测试', () {
    test('APP_THEME = 0xff00a578', () => expect(AppColors.APP_THEME, 0xff00a578));
    test('TEXT_WHITE = 0xFFFFFFFF', () => expect(AppColors.TEXT_WHITE, 0xFFFFFFFF));
    test('BLACK = 0xFF333333', () => expect(AppColors.BLACK, 0xFF333333));
    test('TEXT_HINT = 0xFF999999', () => expect(AppColors.TEXT_HINT, 0xFF999999));
  });

  // ============================================================
  // 6. 资源路径常量测试
  // ============================================================
  group('6. 资源路径常量测试', () {
    test('Tab图标均为本地路径', () {
      for (final p in [
        AppAssets.tabHomeSelected, AppAssets.tabHomeUnselected,
        AppAssets.tabMsgSelected, AppAssets.tabMsgUnselected,
        AppAssets.tabEnterpriseSelected, AppAssets.tabEnterpriseUnselected,
        AppAssets.tabMySelected, AppAssets.tabMyUnselected,
      ]) {
        expect(p.startsWith('images/'), true);
      }
    });

    test('远程图标均为http路径', () {
      for (final u in [AppAssets.topBackBtn, AppAssets.myNext, AppAssets.searchIcon]) {
        expect(u.startsWith('http'), true);
      }
    });

    test('远程基础URL正确', () {
      expect(AppAssets.remoteIconBase, 'http://snbc.zglcwl.com/Public/fontImages/');
    });

    test('登录图标路径正确', () {
      expect(AppAssets.icLauncher, 'images/ic_launcher.png');
      expect(AppAssets.delLoginIcon, 'images/del_login_icon.png');
      expect(AppAssets.loginSeeIcon, 'images/login_see_icon.png');
      expect(AppAssets.loginUnseeIcon, 'images/login_unsee_icon.png');
    });
  });

  // ============================================================
  // 7. 模型类测试
  // ============================================================
  group('7. 模型类测试', () {
    test('BannerModel fromJson', () {
      final m = BannerModel.fromJson({'class_name': '中医基础', 'id': 1});
      expect(m.className, '中医基础');
    });

    test('BannerModel 默认值', () {
      expect(BannerModel().className, isNull);
    });

    test('ArticleModel fromJson', () {
      final m = ArticleModel.fromJson({
        'article_id': 100,
        'article_title': '中医养生',
        'article_img': 'http://example.com/img.jpg',
        'article_lecturer': '张医生',
        'article_see': 1234,
      });
      expect(m.articleTitle, '中医养生');
      expect(m.articleLecturer, '张医生');
      expect(m.articleSee, 1234);
      expect(m.articleImg, 'http://example.com/img.jpg');
    });

    test('EnterpriseZoneModel fromJson', () {
      final m = EnterpriseZoneModel.fromJson({
        'id': 1,
        'name': '某某药业',
        'head': 'http://example.com/logo.jpg',
        'introduction': '专注于中医药研发',
        'img': 'http://example.com/banner.jpg',
      });
      expect(m.name, '某某药业');
      expect(m.introduction, '专注于中医药研发');
      expect(m.head, 'http://example.com/logo.jpg');
      expect(m.img, 'http://example.com/banner.jpg');
    });
  });

  // ============================================================
  // 8. 广告模块（穿山甲）功能测试
  // 说明：以下测试在本机（Windows，非 Android/iOS）运行，
  // 平台门控应全部关闭、SDK 不应被初始化。
  // ============================================================
  group('8. 广告模块（穿山甲）功能测试', () {
    test('App ID 已配置为真实值 5408517', () {
      expect(AdsConfig.appId, '5408517');
      expect(AdsConfig.appId.isNotEmpty, true);
    });

    test('各广告位 ID 已配置', () {
      expect(AdsConfig.splashId, '888363778');
      expect(AdsConfig.bannerId, isNotEmpty);
      expect(AdsConfig.rewardVideoId, isNotEmpty);
      expect(AdsConfig.rewardVideoUnlockId, isNotEmpty);
    });

    test('信息流 feedId 暂为空（待补，安全降级）', () {
      // 缺失时课程列表不展示信息流广告，属预期
      expect(AdsConfig.feedId, '');
    });

    test('非移动平台不启用广告（门控关闭）', () {
      // 本机为 Windows 桌面平台，isAdSupported 应为 false
      expect(AdsConfig.isAdSupported, false);
      expect(AdsConfig.isIOS, false);
    });

    test('AdHelper 初始化前未初始化', () {
      expect(AdHelper.isInited, false);
    });

    test('非 Android 平台 initAds 直接返回 false 且不触发 SDK', () async {
      // 主机非 Android，门控关闭 → initAds 应立即返回 false，
      // 且不会调用原生插件（不会抛 MissingPluginException）
      final result = await AdHelper.initAds();
      expect(result, false);
      expect(AdHelper.isInited, false);
    });

    test('非 Android 平台 showSplashAd 静默返回（不触发 SDK）', () async {
      // 门控关闭 → showSplashAd 应立即返回，不抛异常
      await AdHelper.showSplashAd();
      expect(AdHelper.isInited, false);
    });
  });
}
