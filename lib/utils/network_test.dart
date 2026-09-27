import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkTest {
  static Future<bool> testConnection() async {
    try {
      debugPrint('🔍 开始测试网络连接...');
      final dio = Dio();
      final response = await dio.get(
        'http://snbc.zglcwl.com',
        options: Options(
          sendTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );
      debugPrint('✅ 网络连接测试成功: ${response.statusCode}');
      return true;
    } catch (e) {
      debugPrint('❌ 网络连接测试失败: $e');
      return false;
    }
  }

  static Future<void> testCourseAPI() async {
    try {
      debugPrint('🔍 开始测试课程 API...');
      final dio = Dio(BaseOptions(
        baseUrl: "http://snbc.zglcwl.com/index.php/home/Index",
        headers: {'platform': 'android', 'version': 11.0},
        connectTimeout: Duration(milliseconds: 10000),
        receiveTimeout: Duration(milliseconds: 10000),
      ));

      FormData formData = FormData.fromMap({
        "begin": 0,
        "end": 20,
        "keyword": "",
      });

      final response = await dio.post("/course", data: formData);
      debugPrint('✅ 课程 API 测试成功');
      debugPrint('📊 响应数据: ${response.data}');
    } catch (e) {
      debugPrint('❌ 课程 API 测试失败: $e');
    }
  }
}
