import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';

import 'ads_config.dart';

/// 穿山甲广告封装
///
/// 合规要求（穿山甲官方接入规范）：
/// 广告 SDK 必须在**用户同意隐私协议之后**才能初始化，开屏广告同理。
/// 因此本类不提供启动时自动初始化，全部由调用方在确认同意后触发。
///
/// 当前仅 Android 生效（iOS 端插件内置 SDK 版本过低，暂不接入）
class AdHelper {
  static bool _inited = false;

  /// 广告 SDK 是否已初始化
  static bool get isInited => _inited;

  /// 当前平台是否走广告逻辑（Android only）
  static bool get _enabled => AdsConfig.isAdSupported && Platform.isAndroid;

  /// 初始化广告 SDK（幂等）
  /// 返回是否初始化成功；失败时所有广告都不会展示，但不影响主流程
  static Future<bool> initAds() async {
    if (_inited) return true;
    if (!_enabled) return false;
    try {
      final bool result = await FlutterPangleAds.initAd(
        AdsConfig.appId,
        directDownloadNetworkType: [
          NetworkType.kNetworkStateMobile,
          NetworkType.kNetworkStateWifi,
        ],
      );
      _inited = result;
      debugPrint('穿山甲广告SDK 初始化${result ? '成功' : '失败'}');
      if (result) {
        // 打开个性化广告推荐
        await FlutterPangleAds.setUserExtData(personalAdsType: '1');
      }
      return result;
    } catch (e) {
      debugPrint('穿山甲广告SDK 初始化异常: $e');
      return false;
    }
  }

  /// 展示开屏广告
  /// 无填充或失败时静默跳过（不会阻塞进入首页）
  /// [timeout] 加载超时时间，超时后自动关闭
  static Future<void> showSplashAd({double timeout = 3.5}) async {
    if (!_enabled || !_inited) return;
    try {
      final bool result = await FlutterPangleAds.showSplashAd(
        AdsConfig.splashId,
        timeout: timeout,
      );
      debugPrint('展示开屏广告${result ? '成功' : '失败（可能无填充）'}');
    } catch (e) {
      debugPrint('展示开屏广告异常: $e');
    }
  }
}
