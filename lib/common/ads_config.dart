import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

/// 穿山甲（字节跳动 CSJ）广告配置
/// ID 申请：穿山甲媒体平台 https://www.csjplatform.com/
///
/// ID 来源说明：
/// - appId / splashId 取自 git 历史提交 0abde37（2023 年已上线版本的接入代码）
/// - 各广告位 ID 取自当前工作副本中注释掉的接入代码（958xxx 系列，为后期版本）
/// - 括号内为 2023 年旧版对应 ID（953xxx 系列），如后台已废弃请忽略
class AdsConfig {
  /// 应用 App ID
  static String get appId => '5408517';

  /// 开屏广告位 ID（原始版本在启动时展示；当前版本未启用，需配合 splash 页恢复）
  static String get splashId => '888363778';

  /// Banner 广告位 ID（学术资料页顶部）            [旧版 953318189]
  static String get bannerId => '958209237';

  /// Banner 广告位 ID（企业专区页）                [旧版 953318196]
  static String get bannerEnterpriseId => '953318196';

  /// Banner 广告位 ID（首页）                      [旧版 953317270]
  static String get bannerHomeId => '953317270';

  /// 激励视频广告位 ID（学术资料页 AppBar 入口）   [旧版 953317548]
  static String get rewardVideoId => '958209272';

  /// 激励视频广告位 ID（课程列表「观看视频查看详情」解锁）
  static String get rewardVideoUnlockId => '958216153';

  /// 信息流广告位 ID（课程列表）
  /// TODO: 原代码中该 ID 已丢失（git 历史也无），需在穿山甲后台确认后填入。
  /// 为空时 loadFeedAd 会被跳过，列表不展示信息流广告（安全降级）
  static String get feedId => '';

  /// 当前平台是否支持广告（插件仅支持 Android/iOS，Web 不支持）
  static bool get isAdSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// 是否为 iOS 平台
  static bool get isIOS => !kIsWeb && Platform.isIOS;
}
