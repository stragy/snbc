import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';

import '../course_classify_detail_page.dart';

class CourseClassifyWidget extends StatelessWidget {
  CourseClassifyWidget({Key key, this.data}) : super(key: key);
  var data;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildGoods(context);
  }

  Widget buildGoods(context) {
    return InkWell(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  data['course_img'],
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(data['course_title'],
                          style: TextStyle(
                              color: Color(AppColors.TEXT_BLACK), fontSize: 14),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 5),
                      child: Text(data['course_introduction'],
                          style: TextStyle(
                              color: Color(AppColors.TEXT_BLACK), fontSize: 12),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        child: Text("主讲：${data['course_lecturer']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.Text_GRAY)),
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis)),
                  ],
                ))
              ],
            ),
            Container(
              child: Divider(
                height: 1,
                color: Color(AppColors.BG_EE),
              ),
              margin: EdgeInsets.only(top: 10, bottom: 10),
            )
          ],
        ),
      ),
      onTap: () {
        // showRewardVideoAd();

        this.pushPage(context, CourseClassifyDetailPage(id: data['course_id']));
      },
    );
  }

  void pushPage(context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  var _result;

  /// 展示激励视频广告
  Future<void> showRewardVideoAd() async {
    try {
      bool result = await FlutterPangleAds.showRewardVideoAd(
        "953317548",
        customData: 'customData',
        userId: 'userId',
      );
      _result = "展示激励视频广告${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result =
          "展示激励视频广告失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    print(_result);
  }
}
