import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/enterprise_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/case_share_page.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/utils/ui_util.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'market_survey_page.dart';
import 'micro_class_detail_page.dart';
import 'micro_class_page.dart';

class EnterpriseInformationPage extends StatefulWidget {
  const EnterpriseInformationPage({
    super.key,
    required this.id,
  });

  final dynamic id;

  @override
  State<EnterpriseInformationPage> createState() =>
      _EnterpriseInformationPageState();
}

class _EnterpriseInformationPageState extends State<EnterpriseInformationPage>
    with SingleTickerProviderStateMixin {
  EnterpriseZoneModel model = EnterpriseZoneModel();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);

    getCompany();
  }

  Future<void> getCompany() async {
    FormData formData = FormData.fromMap({
      "id": widget.id,
    });
    await Request.getInstance().post("/company", (data) async {
      model = EnterpriseZoneModel.fromJson(data);
      setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(AppColors.APP_THEME),
          leading: IconButton(
              icon: Image.network(
                "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
                width: 11,
                height: 19,
                fit: BoxFit.fill,
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
              color: Color(AppColors.APP_THEME),
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: model.head != null
                                  ? Image.network(
                                      model.head!,
                                      width: 55,
                                      height: 55,
                                    )
                                  : SizedBox(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(model.head != null ? (model.name ?? '') : "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                    fontFamily: 'PingFang')),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            //背景
                            color: Color(AppColors.TEXT_WHITE),
                            //设置四周圆角 角度
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          margin:
                              EdgeInsets.only(right: 15, top: 18, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          child: Text("企业风采",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(AppColors.APP_THEME))),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebPage(
                                        name: "企业风采",
                                        url: model.style ?? '',
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
              indicatorColor: Color(AppColors.APP_THEME),
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
                MicroClassPage(
                  id: widget.id,
                ),
                MarketSurveyPage(id: widget.id),
                CaseSharePage(id: widget.id),
              ],
            ))
          ],
        ));
  }

  Widget swiper() {
    return Container(
      width: DeviceUtils.sreenWidth(context),
      height: DeviceUtils.sreenWidth(context) * 0.34,
      margin: EdgeInsets.only(top: 15, left: 10, right: 10),
      child: model.banner != null && model.banner!.length > 0
          ? Swiper(
              itemBuilder: _swiperBuilder,
              itemCount: model.banner != null && model.banner!.length > 0
                  ? model.banner!.length
                  : 0,
              scrollDirection: Axis.horizontal,
              autoplay: true,
              pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                color: Color(AppColors.TEXT_HINT),
                activeColor: Color(AppColors.APP_THEME),
                size: 7,
                activeSize: 7,
              )),
              // viewportFraction: 0.86,
              // scale: 0.92,
              onTap: (index) {
                if (model.banner?[index]['link'].toString().isNotEmpty ?? false) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MicroClassifyDetailPage(
                              id: model.banner?[index]['link'])));
                }
              },
            )
          : SizedBox(),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        model.banner?[index]['img'] ?? '',
        fit: BoxFit.fill,
      ),
    ));
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
