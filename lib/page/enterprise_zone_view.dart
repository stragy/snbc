import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/enterprise_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/enterprise_information_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_pangle_ads/view/ad_banner_widget.dart';

//企业专区
class EnterpriseZoneView extends StatefulWidget {
  @override
  _EnterpriseZoneViewState createState() => _EnterpriseZoneViewState();
}

class _EnterpriseZoneViewState extends State<EnterpriseZoneView> {
  int begin = 0;
  List<EnterpriseZoneModel> list = new List();
  EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompany();
  }

  getCompany() async {
    FormData formData = new FormData.fromMap({
      "page": begin,
      "pagesize": 20,
    });
    await Request.getInstance().post("/companyList", (data) async {
      setState(() {
        list = (data as List)
            .map((item) => EnterpriseZoneModel.fromJSON(item))
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
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        elevation: 0,
        //去掉Appbar底部阴影

        automaticallyImplyLeading: true,
        title: Text('企业专区'),
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
            width: 320,
            height: 120,
            autoClose: false,
            posId: "953318196",
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
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: new BoxDecoration(
                        //背景
                        color: Colors.white,
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: CachedNetworkImage(
                                  width: 55,
                                  height: 43,
                                  imageUrl: list[index].head,
                                ),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 15),
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          list[index].name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(AppColors.BLACK)),
                                        ),
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            //背景
                                            color: Color(AppColors.APP_ThEME),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                          ),
                                          child: Text("进入专区",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white)),
                                          margin: EdgeInsets.only(
                                              right: 15, top: 15, bottom: 10),
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 2,
                                              bottom: 2),
                                        ),
                                        onTap: () {
                                          this.pushPage(
                                              EnterpriseInformationPage(
                                                  id: list[index].id));
                                        },
                                      )
                                    ],
                                  ),
                                  Text(list[index].introduction,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(AppColors.ICON_GRAY))),
                                ],
                              ))
                            ],
                          ),
                          Container(
                            child: CachedNetworkImage(
                              height: 130,
                              imageUrl: list[index].img,
                            ),
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  );
                }),
            onLoad: () {
              begin++;
              getCompany();
            },
            onRefresh: () {
              begin = 0;

              getCompany();
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
