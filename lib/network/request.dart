import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request {
  static const String _objKey = "obj";
  static const String _codeKey = "code";
  static const String _baseUrl = "http://snbc.zglcwl.com/index.php/home/Index";

  late final Dio _dio;
  static Request? _instance;

  static Request getInstance() {
    _instance ??= Request._();
    return _instance!;
  }

  Request._() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {'platform': 'android', 'version': 11.0},
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      responseType: ResponseType.json,
    ));

    _dio.interceptors.addAll([
      _LogInterceptor(),
      _TokenInterceptor(),
    ]);
  }

  Future<void> get(String url, Function successCallBack,
      {Map<String, dynamic>? params, Function? errorCallBack, bool silent = false}) async {
    await _request(url, successCallBack,
        params: params, errorCallBack: errorCallBack, method: 'GET', silent: silent);
  }

  Future<void> post(String url, Function successCallBack,
      {params, Function? errorCallBack, bool silent = false}) async {
    await _request(url, successCallBack,
        params: params, errorCallBack: errorCallBack, method: 'POST', silent: silent);
  }

  Future<void> _request(String url, Function successCallBack,
      {params, Function? errorCallBack, required String method, bool silent = false}) async {
    try {
      Response response;
      if (method == 'GET') {
        response = await _dio.get(url, queryParameters: params);
      } else {
        response = await _dio.post(url, data: params);
      }

      if (response.statusCode != 200) {
        final msg = '服务器错误 (${response.statusCode})';
        if (!silent) _showErrorToast(msg);
        _handleError(errorCallBack, msg);
        return;
      }

      final dataMap = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {};

      if (dataMap[_codeKey] != 1) {
        final message = dataMap["message"]?.toString() ?? dataMap["msg"]?.toString() ?? '请求失败，请稍后重试';
        if (!silent) _showErrorToast(message);
        _handleError(errorCallBack, '业务错误: $message');
        return;
      }

      successCallBack(dataMap[_objKey]);
    } on DioException catch (e) {
      String msg;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        msg = '网络连接超时，请检查网络后重试';
      } else if (e.type == DioExceptionType.connectionError) {
        msg = '网络连接失败，请检查网络设置';
      } else if (e.type == DioExceptionType.sendTimeout) {
        msg = '请求发送超时，请重试';
      } else {
        msg = '网络请求异常，请稍后重试';
      }
      debugPrint('[Request] DioException: type=${e.type}, message=${e.message}');
      if (!silent) _showErrorToast(msg);
      _handleError(errorCallBack, msg);
    } catch (e) {
      final msg = '请求异常，请稍后重试';
      debugPrint('[Request] Unknown error: $e');
      if (!silent) _showErrorToast(msg);
      _handleError(errorCallBack, msg);
    }
  }

  /// 显示错误提示
  void _showErrorToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        fontSize: 14,
        textColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF000000));
  }

  void _handleError(Function? errorCallBack, String error) {
    debugPrint('[Request] Error: $error');
    errorCallBack?.call(error);
  }
}

/// 日志拦截器
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[Request] ${options.method} ${options.baseUrl}${options.path}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[Request] Error: ${err.message}');
    handler.next(err);
  }
}

/// Token 拦截器
class _TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final sp = await SharedPreferences.getInstance();
    final userId = sp.getString('id') ?? '';
    if (userId.isNotEmpty) {
      options.headers['user_id'] = userId;
    }
    handler.next(options);
  }
}
