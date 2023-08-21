import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Request {
  static final String GET = "get";
  static final String POST = "post";
  static final String OBJ = "obj";
  static final String CODE = "code";
static final String baseUrl="http://snbc.zglcwl.com/index.php/home/Index";
  Dio dio;
  static Request _instance;

  static Request getInstance() {
    if (_instance == null) {
      _instance = Request();
    }
    return _instance;
  }

  Request() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
//      baseUrl: "http://api.lingyuangou365.com/api.php",
      headers: {'platform': 'android', 'version': 11.0},
      connectTimeout: 5000,
      receiveTimeout: 100000,

    ));
  }

  //get请求
  get(String url, Function successCallBack,
      {params, Function errorCallBack}) async {
    _requstHttpGet(url, successCallBack, params, errorCallBack);
  }

  //post请求
  post(String url, Function successCallBack,
      {params, Function errorCallBack}) async {
    _requstHttpPost(url, successCallBack, params, errorCallBack);
  }

  _requstHttpPost(String url, Function successCallBack,
      [ FormData params, Function errorCallBack]) async {
    String errorMsg = '';
    int code;

    try {
      Response response;
//      _addStartHttpInterceptor(dio); //添加请求之前的拦截器
        if (params != null ) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      code = response.statusCode;
      if (code != 200) {
        errorMsg = '错误码：' + code.toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }

      Map<String, dynamic> dataMap = json.decode(response.data);
      if (dataMap != null && dataMap[CODE] != 1) {

        Fluttertoast.showToast(msg: dataMap["message"].toString());
        errorMsg =
            '错误码：' + dataMap[CODE].toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }

      if (successCallBack != null) {
        // print('------------------------');
        // print(dataMap);
        successCallBack(dataMap[OBJ]);
      }
    } catch (exception) {
      _error(errorCallBack, exception.toString());
    }
  }
  _requstHttpGet(String url, Function successCallBack,
      [ Map params, Function errorCallBack]) async {
    String errorMsg = '';
    int code;

    try {
      Response response;
//      _addStartHttpInterceptor(dio); //添加请求之前的拦截器
        if (params != null ) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      code = response.statusCode;
      if (code != 200) {
        errorMsg = '错误码：' + code.toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }

      Map<String, dynamic> dataMap = json.decode(response.data);
      if (dataMap != null && dataMap[CODE] != 1) {

        Fluttertoast.showToast(msg: dataMap["message"].toString());
        errorMsg =
            '错误码：' + dataMap[CODE].toString() + '，' + response.data.toString();
        _error(errorCallBack, errorMsg);
        return;
      }

      if (successCallBack != null) {
        // print('------------------------');
        // print(dataMap);
        successCallBack(dataMap[OBJ]);
      }
    } catch (exception) {
      _error(errorCallBack, exception.toString());
    }
  }

  _error(Function errorCallBack, String error) {
    print("error====" + error);
//    Fluttertoast.showToast(
//        msg: error.toString(),
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER);
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }

//  _addStartHttpInterceptor(Dio dio) {
//    dio.interceptor.request.onSend = (Options options) {
//      // 在请求被发送之前做一些事情   比如加密的一些操作 或者添加token等参数 对head 或者请求参数进行加工处理
//      Map<String, dynamic> headers = options.headers;
//      Map<String, dynamic> body = options.data;
//      /*request['token'] = '1111111111';
//      headers['addParam'] = 'aaaaaaaaaaaaaaa';*/
//      return options;
//    };
//  }
}
