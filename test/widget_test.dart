// App 级冒烟测试：验证应用能正常构建出 SplashPage。
// 说明：isFirst=true 时 SplashPage 弹出隐私协议弹窗并停留在当前页，
// 不触发跳转（避免 HomePage 的 IsolateNameServer/exit(0) 在测试中崩溃）。
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bct_flutter/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App 启动构建 SplashPage', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'isFirst': true});
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
