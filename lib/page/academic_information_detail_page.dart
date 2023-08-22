import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/article_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AcademicInformationDetailPage extends StatefulWidget {
  AcademicInformationDetailPage({
    @required this.id,
  });

  var id;

  @override
  _AcademicInformationDetailState createState() =>
      _AcademicInformationDetailState(article_id: id);
}

class _AcademicInformationDetailState
    extends State<AcademicInformationDetailPage> {
  ArticleModel model = new ArticleModel();

  _AcademicInformationDetailState({
    @required this.article_id,
  });

  var article_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArtile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //去掉Appbar底部阴影
        leading: IconButton(
            icon:  Image.network(
              "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
              width: 11,
              height: 19,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: true,
        title: Text(
          model.article_title != null ? model.article_title : "文章详情",

        ),
        backgroundColor: Color(AppColors.APP_ThEME),
        centerTitle: true,
        brightness: Brightness.dark,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        primary: true,
      ),
      body: ListView(
        children: [
         Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Text(
                model.article_title != null ? model.article_title : "",
                style: TextStyle(fontSize: 18, color: Color(AppColors.BLACK)),
              ),

          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Text(
              model.article_lecturer != null ? model.article_lecturer : "",
              style: TextStyle(fontSize: 16, color: Color(AppColors.Text_GRAY)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Text(
              model.add_time != null
                  ? "发布日期：${fromNow(int.parse(model.add_time))}"
                  : "",
              style: TextStyle(fontSize: 14, color: Color(AppColors.Text_GRAY)),
            ),
          ),
           Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Text(
              model.article_content != null ? model.article_content : "",
              style: TextStyle(fontSize: 16, color: Color(AppColors.Text_GRAY),),maxLines: 100,
            ),
          )
        ],
      ),
    );
  }
   String fromNow(int timeStamp) {
    /// 因为dart里面并没有实现时区的设置，只能手动设置了

    int now = DateTime.now().millisecondsSinceEpoch + 8 * 3600000;
    double distance = (now - timeStamp) / 60000;
    // 大于24小时就直接显示日期
    if (distance > 24 * 60) {
      DateTime time =
      DateTime.fromMillisecondsSinceEpoch((timeStamp + 8 * 3600) * 1000);
      return DateFormat('yyyy/MM/dd HH:mm').format(time);
    }

    if (distance > 60 && distance < 24 * 60) {
      return '${(distance / 60).toStringAsFixed(0)}小时前';
    }

    if (distance < 60 && distance > 1) {
      return '${distance.toStringAsFixed(0)}分钟前';
    } else {
      DateTime time =
      DateTime.fromMillisecondsSinceEpoch((timeStamp + 8 * 3600) * 1000);
      return DateFormat('yyyy/MM/dd HH:mm').format(time);
    }
  }
  getArtile() async {
    FormData formData = new FormData.fromMap({
      "article_id": article_id,
    });
    await Request.getInstance().post("/articleDetail", (data) async {
      model = ArticleModel.fromJSON(data);
      setState(() {});
    }, params: formData);
  }
}
