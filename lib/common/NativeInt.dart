
import 'package:flutter/services.dart';

import 'configuration.dart';

Future<String> EvenInfo(String evenInfo,{Map<String,String> mapInfo}) async {
  String result;
  try {
    final level = await  Config.stream.invokeMethod(evenInfo,
      mapInfo
    );
    result =  level.toString() ;
  } on PlatformException {
    result = 'Failed to get battery level.';
  }
  return result;
}