import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';

abstract class Config{
  static const stream = const MethodChannel('com.heiya.myflutterframe/stream');
  static FluroRouter router;
}