import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/page/widget/dialog_share.dart';
import 'package:bct_flutter/utils/ui_util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  WebPage({
    @required this.url,
    @required this.name,
    @required this.isShare,

  });

  final String url;
  final String name;
  final bool isShare;


  @override
  _WebPage createState() => _WebPage(url: url, name: name,isShare:isShare );
}

class _WebPage extends State<WebPage> {
  _WebPage({
    @required this.url,
    @required this.name,
    @required this.isShare,
  });

  final String url;
  final String name;
  final bool isShare;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //标题居中
        backgroundColor: Color(AppColors.APP_ThEME),
        centerTitle: true,
        title: Text(name),
        leading: IconButton(
          icon:  Image.network(
            "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
            width: 11,
            height: 19,
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.pop(context, "refresh");
          },
        ),

        //后面放置图标
        actions: <Widget>[
          isShare?IconButton(
            icon: Icon(Icons.share, size: 20),
            color: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  return DialogShare(url: url);
                },
              );
            },
          ):SizedBox()
        ],
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
