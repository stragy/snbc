import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/enterprise_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/enterprise_information_page.dart';
import 'package:bct_flutter/utils/event_bus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//企业专区
class EnterpriseZoneView extends StatefulWidget {
  const EnterpriseZoneView({super.key});

  @override
  State<EnterpriseZoneView> createState() => _EnterpriseZoneViewState();
}

class _EnterpriseZoneViewState extends State<EnterpriseZoneView> {
  int begin = 0;
  List<EnterpriseZoneModel> list = <EnterpriseZoneModel>[];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  var bus = EventBus();

  @override
  void initState() {
    super.initState();
    getCompany();
  }

  Future<void> getCompany() async {
    FormData formData = FormData.fromMap({
      "page": begin,
      "pagesize": 20,
    });
    await Request.getInstance().post("/companyList", (data) async {
      setState(() {
        list = (data as List)
            .map((item) => EnterpriseZoneModel.fromJson(item))
            .toList();
      });
      _refreshController.refreshCompleted();
      if (list.length % 20 != 0) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        elevation: 0,
        //去掉Appbar底部阴影

        automaticallyImplyLeading: false,
        title: Text('企业专区'),
        backgroundColor: Color(AppColors.APP_THEME),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        primary: true,
        leading: null,
      ),
      body: Column(
        children: [
          Expanded(
              child: SmartRefresher(
            header: ClassicHeader(),
            footer: ClassicFooter(),
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
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
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 15),
                                child: Image.network(
                                  list[index].head ?? '',
                                  width: 55,
                                  height: 43,
                                ),
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
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Text(
                                          list[index].name ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(AppColors.BLACK)),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            //背景
                                            color: Color(AppColors.APP_THEME),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                          ),
                                          margin: EdgeInsets.only(
                                              right: 15, top: 15, bottom: 10),
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 2,
                                              bottom: 2),
                                          child: Text("进入专区",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white)),
                                        ),
                                        onTap: () {
                                          pushPage(EnterpriseInformationPage(
                                              id: list[index].id));
                                        },
                                      )
                                    ],
                                  ),
                                  Text(list[index].introduction ?? '',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(AppColors.ICON_GRAY))),
                                ],
                              ))
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Image.network(
                              list[index].img ?? '',
                              height: 130,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  );
                }),
            onLoading: () async {
              begin++;
              await getCompany();
            },
            onRefresh: () async {
              begin = 0;
              await getCompany();
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
