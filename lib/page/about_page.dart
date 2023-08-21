import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/page/feedback_page.dart';
import 'package:bct_flutter/page/widget/list_cell.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color(0xfff5f5f5),
            appBar: AppBar(
              elevation: 0,
              //去掉Appbar底部阴影
              leading:
              IconButton(
                  icon:  CachedNetworkImage(
                    width: 11,
                    height: 19,
                    fit: BoxFit.fill,
                    imageUrl: "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: true,
              title: Text('关于'),
              backgroundColor: Color(AppColors.APP_ThEME),
              centerTitle: true,
              brightness: Brightness.dark,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              toolbarOpacity: 1.0,
              bottomOpacity: 1.0,
              primary: true,
            ),
            body: Column(
              children: [
                Container(
                  height: ScreenUtil().setWidth(188),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
                  child:
                  CachedNetworkImage(
                    width: ScreenUtil().setWidth(188),
                    height: ScreenUtil().setWidth(188),
                    fit: BoxFit.fill,
                    imageUrl: "http://snbc.zglcwl.com/Public/fontImages/ic_launcher.png",
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 25),
                  child: Text(
                    "神农百草",
                    style: TextStyle(
                        fontSize: 16, color: Color(AppColors.APP_ThEME)),
                  ),
                ),
                ListCell(
                  title: '意见反馈',
                  isDivider: true,
                  onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedbackPage()));},
                ),
              ],
            ));
  }
}
