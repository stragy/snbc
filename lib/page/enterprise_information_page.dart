import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/article_model.dart';
import 'package:bct_flutter/model/enterprise_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/case_share_page.dart';
import 'package:bct_flutter/page/course_classify_detail_page.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/utils/ui_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'market_survey_page.dart';
import 'micro_class_detail_page.dart';
import 'micro_class_page.dart';

class EnterpriseInformationPage extends StatefulWidget {
  EnterpriseInformationPage({
    @required this.id,
  });

  var id;

  @override
  _EnterpriseInformationPageState createState() =>
      _EnterpriseInformationPageState(id: id);
}

class _EnterpriseInformationPageState extends State<EnterpriseInformationPage>
    with SingleTickerProviderStateMixin {
  EnterpriseZoneModel model = new EnterpriseZoneModel();
  TabController tabController;

  _EnterpriseInformationPageState({
    @required this.id,
  });

  var id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3);

    getCompany();
  }

  getCompany() async {
    FormData formData = new FormData.fromMap({
      "id": id,
    });
    await Request.getInstance().post("/company", (data) async {
      model = EnterpriseZoneModel.fromJSON(data);
      setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(AppColors.APP_ThEME),
          leading: IconButton(
              icon:  CachedNetworkImage(
                width: 11,
                height: 19,
                fit: BoxFit.fill,
                imageUrl: "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            '企业资料',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 18,
                fontFamily: 'PingFang'),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Color(AppColors.APP_ThEME),
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: model != null && model.head != null
                                  ? CachedNetworkImage(
                                      width: 55,
                                      height: 55,
                                      imageUrl: model.head,
                                    )
                                  : SizedBox(),
                            ),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                          ),
                          Container(
                            child: Text(
                                model != null && model.head != null
                                    ? model.name
                                    : "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                    fontFamily: 'PingFang')),
                            margin: EdgeInsets.only(top: 10),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: new BoxDecoration(
                            //背景
                            color: Color(AppColors.TEXT_WIT),
                            //设置四周圆角 角度
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Text("企业风采",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(AppColors.APP_ThEME))),
                          margin:
                              EdgeInsets.only(right: 15, top: 18, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebPage(
                                        name: "企业风采",
                                        url: model.style,
                                        isShare: true,
                                      )));
                        },
                      )
                    ],
                  ),
                  swiper(),
                ],
              ),
            ),
            TabBar(
              controller: tabController,
              labelColor: Colors.black,
              indicatorColor: Color(AppColors.APP_ThEME),
              tabs: <Widget>[
                Tab(text: '在线微课堂'),
                Tab(text: '市场调研'),
                Tab(text: '病例分享'),
              ],
            ),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: <Widget>[
                new MicroClassPage(
                  id: id,
                ),
                MarketSurveyPage(id: id),
                CaseSharePage(id: id),
              ],
            ))
          ],
        ));
  }

  Widget swiper() {
    return new Container(
      width: DeviceUtils.sreenWidth(context),
      height: DeviceUtils.sreenWidth(context) * 0.34,
      margin: EdgeInsets.only(top: 15, left: 10, right: 10),
      child: model.banner != null && model.banner.length > 0
          ? Swiper(
              itemBuilder: _swiperBuilder,
              itemCount: model.banner != null && model.banner.length > 0
                  ? model.banner.length
                  : 0,
              scrollDirection: Axis.horizontal,
              autoplay: true,
              pagination: new SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                color: Color(AppColors.TEXT_HINT),
                activeColor: Color(AppColors.APP_ThEME),
                size: 7,
                activeSize: 7,
              )),
              // viewportFraction: 0.86,
              // scale: 0.92,
              onTap: (index) {
                if(model.banner[index]['link'].toString().isNotEmpty)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MicroClassifyDetailPage(
                            id: model.banner[index]['link'])));
              },
            )
          : SizedBox(),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        model.banner[index]['img'],
        fit: BoxFit.fill,
      ),
    ));
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
