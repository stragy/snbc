/* ignore_for_file: file_names */
import 'package:flutter/services.dart';

import 'configuration.dart';

/// Preferred lowerCamelCase API
Future<String> evenInfo(String method, {Map<String, String>? mapInfo}) async {
  try {
    final level = await Config.stream.invokeMethod(method, mapInfo);
    return level.toString();
  } on PlatformException {
    return 'Failed to get battery level.';
  }
}
