# Flutter 项目逐步修复计划

## 🚀 第一步：环境准备和备份

### 1.1 创建备份分支
```bash
git checkout -b backup-before-fixes
git add .
git commit -m "备份修复前的代码状态"
git checkout main
```

### 1.2 更新 Flutter 环境
```bash
flutter doctor
flutter upgrade
flutter clean
```

## 🔧 第二步：更新依赖配置

### 2.1 更新 pubspec.yaml
需要更新的关键依赖：

```yaml
environment:
  sdk: ">=2.17.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # 更新关键依赖
  fluwx: ^3.0.0
  flutter_downloader: ^1.11.0
  flutter_screenutil: ^5.9.0
  flutter_picker: ^2.1.0
```

### 2.2 获取新依赖
```bash
flutter pub get
```

## 🎯 第三步：高优先级错误修复

### 3.1 修复微信 API 错误 (最高优先级)

**文件**: `lib/main.dart:23`

**修复前**:
```dart
await fluwx.registerWxApi(
  appId: "your_app_id",
  doOnAndroid: true,
  doOnIOS: true,
);
```

**修复后**:
```dart
await fluwx.registerApi(
  appId: "your_app_id",
  doOnAndroid: true,
  doOnIOS: true,
);
```

**文件**: `lib/page/widget/dialog_share.dart:117`

**修复前**:
```dart
fluwx.shareToWeChat(model);
```

**修复后**:
```dart
fluwx.share(WeChatShareTextModel(
  text: "分享内容",
  scene: WeChatScene.SESSION,
));
```

### 3.2 修复 AppBar brightness 错误

**影响文件**: 多个页面文件

**修复前**:
```dart
AppBar(
  brightness: Brightness.dark,
  title: Text("标题"),
)
```

**修复后**:
```dart
AppBar(
  systemOverlayStyle: SystemUiOverlayStyle.dark,
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  title: Text("标题"),
)
```

### 3.3 修复 List 构造函数错误

**影响文件**: 多个文件

**修复前**:
```dart
List<String> list = new List();
```

**修复后**:
```dart
List<String> list = <String>[];
// 或
List<String> list = [];
```

## ⚠️ 第四步：中优先级错误修复

### 4.1 修复 SendPort 空安全错误

**文件**: `lib/page/catalogue_page.dart:66`, `lib/page/download_page1.dart:101`

**修复前**:
```dart
final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
```

**修复后**:
```dart
final SendPort? sendPort = IsolateNameServer.lookupPortByName('downloader_send_port');
if (sendPort != null) {
  // 使用 sendPort
}
```

### 4.2 修复字段初始化错误

**影响文件**: 多个文件

**修复前**:
```dart
Container loadingDialog;
```

**修复后**:
```dart
late Container loadingDialog;
// 或在构造函数中初始化
```

### 4.3 修复 ScreenUtil API 错误

**文件**: `lib/page/MyView.dart:93`, `lib/page/login_page.dart:151`

**修复前**:
```dart
ScreenUtil.screenWidth
ScreenUtil.screenHeightDp
ScreenUtil.init(width: 750, height: 1334, allowFontScaling: false)
```

**修复后**:
```dart
1.sw  // 屏幕宽度
1.sh  // 屏幕高度
ScreenUtil.init(context)
```

## 📝 第五步：低优先级错误修复

### 5.1 修复构造函数参数错误

**影响文件**: 多个 widget 文件

**修复前**:
```dart
TimerCountDownWidget({this.onTimerFinish, this.phone, this.reg})
```

**修复后**:
```dart
TimerCountDownWidget({
  this.onTimerFinish,
  required this.phone,
  required this.reg,
})
```

### 5.2 修复网络请求参数类型错误

**文件**: `lib/network/request.dart:90`

**修复前**:
```dart
Map params = {};
response = await dio.get(url, queryParameters: params);
```

**修复后**:
```dart
Map<String, dynamic> params = <String, dynamic>{};
response = await dio.get(url, queryParameters: params);
```

## 🧪 第六步：测试和验证

### 6.1 编译测试
```bash
flutter analyze
flutter build apk --debug
```

### 6.2 功能测试
- 启动应用
- 测试主要功能
- 检查 UI 显示
- 验证网络请求

### 6.3 错误检查
```bash
flutter doctor
flutter pub deps
```

## 📊 修复进度跟踪

| 步骤 | 状态 | 完成时间 | 备注 |
|------|------|---------|------|
| 环境准备 | ⏳ 待开始 | - | 创建备份分支 |
| 依赖更新 | ⏳ 待开始 | - | 更新 pubspec.yaml |
| 微信 API 修复 | ⏳ 待开始 | - | 最高优先级 |
| AppBar 修复 | ⏳ 待开始 | - | 影响 UI 显示 |
| List 构造函数修复 | ⏳ 待开始 | - | 基础语法错误 |
| 空安全修复 | ⏳ 待开始 | - | 中优先级 |
| API 更新修复 | ⏳ 待开始 | - | 中优先级 |
| 构造函数参数修复 | ⏳ 待开始 | - | 低优先级 |
| 测试验证 | ⏳ 待开始 | - | 最终验证 |

## 🚨 风险控制

### 备份策略
- 每个修复步骤前创建 Git 提交
- 保留原始代码备份
- 使用分支进行修复

### 测试策略
- 每修复一个模块后立即测试
- 保持功能完整性
- 记录修复过程

### 回滚策略
- 如果修复失败，立即回滚到上一个稳定版本
- 分析失败原因，调整修复策略
- 重新开始修复流程

## 🎯 成功标准

修复完成后，项目应该能够：
- ✅ 成功编译运行
- ✅ 所有功能正常工作
- ✅ 符合最新 Flutter 标准
- ✅ 通过代码分析检查
- ✅ 通过功能测试

---

**下一步行动**: 开始执行第一步 - 环境准备和备份 