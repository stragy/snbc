# guanggao 项目长期记忆

## 项目身份
- 路径 `G:/products/project_snbc/guanggao`，Flutter 应用 `bct_flutter`（神农百草 - 中医药在线教育与企业管理平台），与 `G:/products/project_snbc/bct_new` 同源副本。
- 目录名 guanggao 来自「穿山甲广告接入」这一工作主题。

## 约定与环境事实
- 后端：`http://snbc.zglcwl.com/index.php/home/Index`（PHP，HTTP 明文）。
- Flutter 版本：lock 要求 >=3.35，须用 fvm 3.35.1（`$USERPROFILE/fvm/versions/3.35.1/bin/`）。项目 `.fvmrc`(3.10.0) 与 `.fvm/fvm_config.json`(2.8.1) 与 lock(>=3.35) 三者不一致，勿轻信 fvmrc。
- **本机 flutter/dart 命令普遍崩溃**：`OS error 231 所有的管道范例都在使用中`（系统级命名管道耗尽），凡需 spawn 子进程的（`--version` / `analyze` / `compile` / doctor）都失败。
  - 例外：`flutter pub get` 会真正成功，只在中途/结尾崩溃；可从崩溃报告的 Plugins 列表或 pubspec.lock 确认结果。
  - API 正确性验证方式：直接读 pub cache 中包源码核对签名（cache 目录 `E:/dart_pub_cache/hosted/...`）。
  - 崩溃日志会在项目根生成 `flutter_0N.log`，事后清理。
- pub 镜像为清华源（mirrors.tuna.tsinghua.edu.cn）。

## 广告（穿山甲）架构
- 配置集中在 `lib/common/ads_config.dart`（appId + 各广告位 ID + `isAdSupported` 平台判断），改 ID 只改这一处。
- **App ID: 5408517**（git 提交 0abde37 挖出，真实值）。开屏 888363778（未启用）。
- 广告位：Banner 958209237（学术资料页）、激励 958209272（学术页入口）、激励 958216153（课程解锁）；企业专区/首页 Banner 的旧 ID（953318196/953317270）也在配置里备用。**信息流 feedId 缺失待补**。
- **开屏广告已恢复（Android only）**：`lib/common/ad_helper.dart` 提供 `initAds()`（幂等）/ `showSplashAd()`；合规时序为 **用户同意隐私协议 → 初始化 SDK → 展示开屏 → 进首页**，SDK 初始化**不得**放在 `main()`。
- 开屏统一走 Flutter 侧（SplashPage→AdHelper）。原生 `SplashAdActivity.java`（LAUNCHER）已改为纯透传启动入口，不再初始化/展示原生开屏——原因：① 原生层早于隐私协议弹窗 init SDK 违规；② Pangle SDK 全局单例，空 appId 的原生 init 会污染 Flutter 侧（appId 5408517）的开屏填充。原生那份曾有空 `PANGLE_APP_ID` 与代码位 102463329，已删除。
- 平台策略：**Android 走广告，iOS 不走**（插件 iOS 锁 `Ads-CN 6.2.1.6`，官方已 7.8.0.5；且 `ios/` 连 Podfile 都没有，从未 pod install）。`AdHelper._enabled = isAdSupported && Platform.isAndroid`。
- 合规 bug 已修：`DataUtils.isFirst()` 默认 `true` 表示「未同意过」，协议弹窗「同意」须 `setFirst(false)`；旧代码写 `setFirst(true)` 导致首次安装永不弹协议。同意后经 `EventBus().send("goHome")` 通知 SplashPage。
- 958xxx = 当前工作副本注释里的后期版本 ID；953xxx = 2023 年提交里的旧版 ID，两者并存时以 958xxx 为准。
- 插件仅支持 Android/iOS，所有广告入口都用 `AdsConfig.isAdSupported` 保护（项目还有 Web 版本）。
