import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketSurveyPage extends StatefulWidget {
  MarketSurveyPage({
    @required this.id,
  });

  var id;

  @override
  _MarketSurveyPageState createState() => _MarketSurveyPageState(id: id);
}

class _MarketSurveyPageState extends State<MarketSurveyPage> {
  _MarketSurveyPageState({
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
    await Request.getInstance().post("/questionnaireList", (data) async {
      setState(() {
        list = data;
      });
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
              return InkWell(
                child: Row(
                  children: [
                    Container(
                      width: 88,
                      height: 60,
                      margin: EdgeInsets.only(
                          left: 15, top: 10, bottom: 10, right: 10),
                      child: Image.network( list[index]['head'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            list[index]['name'],
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(AppColors.TEXT_BLACK)),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              "参与时间：${list[index]['create_time']}-${list[index]['finish_time']}",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(AppColors.TEXT_HINT)),
                            )),
                      ],
                    )
                  ],
                ),
                onTap: () {
                  var url;
                  if (list[index]['can_use'] == 1) {
                    DataUtils.isLogin().then((isLogin) {
                      if (isLogin) {
                        DataUtils.getPhone().then((value) {
                          url =
                              "http://snbc.zglcwl.com/diseaseCase/index-question.html?id=" +
                                  list[index]['id'] +
                                  "&tel="+value;
                        });
                      } else {
                        url =
                            "http://snbc.zglcwl.com/diseaseCase/index-question.html?id=" +
                                list[index]['id'];
                      }
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WebPage(name: list[index]['name'], url: url,isShare: true)));
                  } else {
                    Fluttertoast.showToast(msg: "不在参与时间内");
                  }
                },
              );
            }));
  }
}
