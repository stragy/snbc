import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CaseShareDetailPage extends StatefulWidget {
  CaseShareDetailPage({
    @required this.id,
  });

  var id;

  @override
  _CaseShareDetailPageState createState() => _CaseShareDetailPageState(id: id);
}

class _CaseShareDetailPageState extends State<CaseShareDetailPage> {
  _CaseShareDetailPageState({
    @required this.id,
  });

  var id;
  var detail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  getDetail() async {
    print(id);
    FormData formData = new FormData.fromMap({
      "id": id,
    });
    await Request.getInstance().post("/diseaseShare", (data) async {
      detail = data;
      setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              elevation: 0,
              //去掉Appbar底部阴影
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
              automaticallyImplyLeading: true,
              title: Text('病例详情'),
              backgroundColor: Color(AppColors.APP_ThEME),
              centerTitle: true,
              brightness: Brightness.dark,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              toolbarOpacity: 1.0,
              bottomOpacity: 1.0,
              primary: true,
            ),
            body: detail == null
                ? SizedBox()
                : ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "医生信息",
                          style: TextStyle(
                              fontSize: 18, color: Color(AppColors.TEXT_BLACK)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "性别：${detail['doc_sex']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "地区：${detail['area']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "职称：${detail['doc_title']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "医院：${detail['hospital']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "病例正文",
                          style: TextStyle(
                              fontSize: 18, color: Color(AppColors.TEXT_BLACK)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          detail['title'],
                          style: TextStyle(
                              fontSize: 16, color: Color(AppColors.TEXT_BLACK)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "诊断：\n${detail['diagnosis']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "性别：${detail['sex']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "年龄：${detail['age']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "主诉：\n${detail['chief_complaint']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "现病史：\n${detail['history_of_present_illness']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "既往史：\n${detail['past_history']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "个人史：\n${detail['personal_history']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "家族史：\n${detail['family_history']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "过敏史：\n${detail['allergy_history']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "辅助检查：\n${detail['supplementary_examination']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "特殊检查：\n${detail['special_examination']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "治疗方案：\n${detail['treatment_plan']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "临床图片（治疗前）",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1),
                              itemCount: detail['pictures_before'] != null
                                  ? detail['pictures_before'].length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  detail['pictures_before'][index],
                                  fit: BoxFit.cover,
                                );
                              })),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "临床图片（治疗后）",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1),
                              itemCount: detail['pictures_after'] != null
                                  ? detail['pictures_after'].length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  detail['pictures_after'][index],
                                  fit: BoxFit.cover,
                                );
                              })),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "检查图片",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1),
                              itemCount: detail['examination_pictures'] != null
                                  ? detail['examination_pictures'].length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  detail['examination_pictures'][index],
                                  fit: BoxFit.cover,
                                );
                              })),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "图片描述：\n${detail['description_examination_pictures']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "治疗后描述：\n${detail['description_after_treatment']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Text(
                          "提示：\n${detail['tips']}",
                          style: TextStyle(
                              fontSize: 15, color: Color(AppColors.ICON_GRAY)),
                        ),
                      ),
                    ],
                  ));
  }
}
