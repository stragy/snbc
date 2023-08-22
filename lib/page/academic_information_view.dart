import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/article_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/network/request.dart';
import 'package:bct_flutter/page/academic_information_detail_page.dart';
import 'package:bct_flutter/utils/ui_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_pangle_ads/view/ad_banner_widget.dart';

//学术资料
class AcademicInformationView extends StatefulWidget {
  @override
  _AcademicInformationViewState createState() =>
      _AcademicInformationViewState();
}

class _AcademicInformationViewState extends State<AcademicInformationView> {
  int begin = 0;
  List<ArticleModel> list = new List();
  EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArtile();
  }

  getArtile() async {
    FormData formData = new FormData.fromMap({
      "begin": begin,
      "end": 20,
    });
    await Request.getInstance().post("/article", (data) async {
      setState(() {
        list = (data['article'] as List)
            .map((item) => ArticleModel.fromJSON(item))
            .toList();
      });
      _refreshController.finishRefresh(success: true);
      _refreshController.finishLoad(
          success: true, noMore: list.length % 20 != 0);
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text('学术资料'),
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
          AdBannerWidget(
            width: 300,
            height: 75,
            interval: 30,
            show: true,
            posId: "953318189",
          ),
          Expanded(
              child: EasyRefresh(
            header: MaterialHeader(),
            footer: MaterialFooter(),
            controller: _refreshController,
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(list[index].article_img,
                                width: 100,
                                height: 70,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(list[index].article_title,
                                        style: TextStyle(
                                            color: Color(AppColors.TEXT_BLACK),
                                            fontSize: 16),
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "主讲：${list[index].article_lecturer}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Color(AppColors.Text_GRAY)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                child: Image.network(  "http://snbc.zglcwl.com/Public/fontImages/eyes.png",
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.fill,

                                                ),
                                              ),
                                              Text("${list[index].article_see}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(
                                                          AppColors.Text_GRAY)))
                                            ],
                                          )
                                        ],
                                      )),
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
                      this.pushPage(AcademicInformationDetailPage(
                          id: list[index].article_id));
                    },
                  );
                }),
            onRefresh: () {
              begin = 0;
              getArtile();
            },
            onLoad: () {
              begin++;
              getArtile();
            },
          ))
        ],
      ),
    );
  }

  void pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
