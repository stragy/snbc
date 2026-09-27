import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';

abstract class Config{
  static const stream = MethodChannel('com.heiya.myflutterframe/stream');
  static FluroRouter router = FluroRouter();
}