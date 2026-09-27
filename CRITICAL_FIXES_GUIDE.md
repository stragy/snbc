# Critical Fixes Guide for Flutter Project Migration

This guide outlines the most critical fixes needed to migrate this Flutter project to support null safety and modern Flutter APIs.

## 1. Import Fixes

- Replace old ScreenUtil import:
  ```dart
  // OLD
  import 'package:flutter_screenutil/screenutil.dart';
  
  // NEW
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:bct_flutter/utils/screen_util_helper.dart'; // For legacy methods
  ```

## 2. ScreenUtil Usage

- Replace direct ScreenUtil calls:
  ```dart
  // OLD
  ScreenUtil().setWidth(100)
  ScreenUtil().setHeight(50)
  ScreenUtil().setSp(16)
  ScreenUtil.screenWidth
  
  // NEW
  100.w
  50.h
  16.sp
  ScreenUtilHelper.screenWidth
  ```

## 3. AppBar Brightness

- Replace brightness parameter:
  ```dart
  // OLD
  AppBar(
    brightness: Brightness.dark,
    title: Text('Title'),
  )
  
  // NEW
  AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    title: Text('Title'),
  )
  ```
  
  Don't forget to add: `import 'package:flutter/services.dart';`

## 4. List Constructors

- Replace old List constructors:
  ```dart
  // OLD
  List<String> items = new List();
  
  // NEW
  List<String> items = <String>[];
  ```

## 5. Non-nullable Fields

- Add initialization or mark as late:
  ```dart
  // OLD
  Timer _timer;
  
  // NEW - Option 1: Initialize
  Timer _timer = Timer(Duration.zero, () {});
  
  // NEW - Option 2: Mark as late
  late Timer _timer;
  ```

## 6. Required Parameters

- Add required keyword:
  ```dart
  // OLD
  Widget build({@required BuildContext context}) {
  
  // NEW
  Widget build({required BuildContext context}) {
  ```

## 7. Future<void> Returns

- Add async and return statement:
  ```dart
  // OLD
  Future<void> onRefresh() {
    loadData();
  }
  
  // NEW
  Future<void> onRefresh() async {
    await loadData();
    return;
  }
  ```

## 8. SendPort Nullability

- Handle nullable SendPort:
  ```dart
  // OLD
  final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send.send([id, status, progress]);
  
  // NEW
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
  ```

## 9. FlatButton to TextButton

- Replace deprecated FlatButton:
  ```dart
  // OLD
  FlatButton(
    onPressed: () {},
    child: Text('Button'),
  )
  
  // NEW
  TextButton(
    onPressed: () {},
    child: Text('Button'),
  )
  ```

## 10. SnackBar Usage

- Update SnackBar API:
  ```dart
  // OLD
  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Message')));
  
  // NEW
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message')));
  ```

## 11. Handling Nullable Returns

- Handle nullable returns:
  ```dart
  // OLD
  String taskId = await FlutterDownloader.enqueue(...);
  
  // NEW
  String? taskId = await FlutterDownloader.enqueue(...);
  // OR
  String taskId = (await FlutterDownloader.enqueue(...))!;
  ```

## 12. Conditional Method Calls

- Use conditional calls for potentially null objects:
  ```dart
  // OLD
  tasks.map((task) => ...);
  
  // NEW
  tasks?.map((task) => ...) ?? [];
  ```

## 13. Fluwx API Updates

- Use the correct API based on your fluwx version:
  ```dart
  // OLD
  await fluwx.registerWxApi(appId: "wxd92d9077ee8812ee", universalLink: "https://example.com");
  fluwx.shareToWeChat(model);
  
  // NEW (if using newer fluwx)
  await fluwx.registerApp(appId: "wxd92d9077ee8812ee", universalLink: "https://example.com");
  await fluwx.share(model);
  ```

## 14. TextTheme API Changes

- Update TextTheme properties:
  ```dart
  // OLD
  theme.textTheme.headline6
  
  // NEW
  theme.textTheme.titleLarge
  ```

## 15. WebView API Updates

- Update WebView parameters:
  ```dart
  // OLD
  WebView(
    javascriptMode: JavascriptMode.unrestricted,
  )
  
  // NEW
  WebView(
    javascriptMode: JavascriptMode.unrestricted,
  )
  ```
  
  Make sure to use the correct import: `import 'package:webview_flutter/webview_flutter.dart';`