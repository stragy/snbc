import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/page/feedback_page.dart';
import 'package:bct_flutter/page/widget/list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
          elevation: 0,
          //去掉Appbar底部阴影
          leading: IconButton(
              icon: Image.network(
                AppAssets.topBackBtn,
                width: 11,
                height: 19,
                fit: BoxFit.fill,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          automaticallyImplyLeading: true,
          title: Text('关于'),
          backgroundColor: Color(AppColors.APP_THEME),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                child: Image.asset(
                  AppAssets.icLauncher,
                  width: ScreenUtil().setWidth(188),
                  height: ScreenUtil().setWidth(188),
                  fit: BoxFit.fill,
                )),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 25),
              child: Text(
                "神农百草",
                style:
                    TextStyle(fontSize: 16, color: Color(AppColors.APP_THEME)),
              ),
            ),
            ListCell(
              icon: "/about_img.png",
              title: '意见反馈',
              isDivider: true,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
            ),
          ],
        ));
  }
}
