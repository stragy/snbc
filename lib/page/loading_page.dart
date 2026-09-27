import 'package:bct_flutter/common/native_int.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Map<String, String> header = {};
    evenInfo("loadingAd", mapInfo: header);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
