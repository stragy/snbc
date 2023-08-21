import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/case_share_detail_page.dart';
import 'package:flutter/material.dart';

class CaseSharePage extends StatefulWidget {
  CaseSharePage({
    @required this.id,
  });

  var id;

  @override
  _CaseSharePageState createState() => _CaseSharePageState(id: id);
}

class _CaseSharePageState extends State<CaseSharePage> {
  _CaseSharePageState({
    @required this.id,
  });

  var id;
  var list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompany();
  }

  getCompany() async {
    print(id);
    FormData formData = new FormData.fromMap({
      "company_id": id,
    });
    await Request.getInstance().post("/diseaseShareList", (data) async {
      list = data;
      setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
            itemCount: list != null ? list.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              list[index]['title'],
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(AppColors.TEXT_BLACK)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10, right: 15),
                              child: Text(
                                "${list[index]['pv']}人浏览",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(AppColors.TEXT_HINT)),
                              )),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8, left: 15),
                          child: Text(
                            "医生：${list[index]['doc_name']}  ${list[index]['department']}  ${list[index]['doc_title']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.ICON_GRAY)),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 8, left: 15, bottom: 10),
                          child: Text(
                            "医院：${list[index]['hospital']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.ICON_GRAY)),
                          )),
                      Divider(
                        height: 1,
                        color: Color(AppColors.BG_EE),
                      )
                    ],
                  ),
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CaseShareDetailPage(id: list[index]['id'])));
                },
              );
            }));
  }
}
