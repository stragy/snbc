import 'package:bct_flutter/common/NativeInt.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<LoadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, String> header = Map();
    EvenInfo("loadingAd", mapInfo: header);
  }
  @override
  Widget build(BuildContext context) {
   return Container();
  }
}