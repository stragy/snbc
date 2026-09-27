import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/web_page.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketSurveyPage extends StatefulWidget {
  const MarketSurveyPage({
    super.key,
    required this.id,
  });

  final dynamic id;

  @override
  State<MarketSurveyPage> createState() => _MarketSurveyPageState();
}

class _MarketSurveyPageState extends State<MarketSurveyPage> {
  dynamic list;

  @override
  void initState() {
    super.initState();
    getCompany();
  }

  Future<void> getCompany() async {
    debugPrint('${widget.id}');
    FormData formData = FormData.fromMap({
      "company_id": widget.id,
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
                      child: Image.network(
                        list[index]['head'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index]['name'],
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14, color: Color(AppColors.TEXT_BLACK)),
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
                onTap: () async {
                  // Capture the local BuildContext to avoid using State.context across async gaps
                  final localContext = context;
                  String url;
                  if (list[index]['can_use'] == 1) {
                    final isLogin = await DataUtils.isLogin();
                    if (isLogin) {
                      final value = await DataUtils.getPhone();
                      url =
                          "http://snbc.zglcwl.com/diseaseCase/index-question.html?id=${list[index]['id']}&tel=$value";
                    } else {
                      url =
                          "http://snbc.zglcwl.com/diseaseCase/index-question.html?id=${list[index]['id']}";
                    }
                    // Guard navigation with the BuildContext's mounted check (Flutter 3.7+)
                    if (!localContext.mounted) return;
                    Navigator.push(
                        localContext,
                        MaterialPageRoute(
                            builder: (ctx) => WebPage(
                                name: list[index]['name'],
                                url: url,
                                isShare: true)));
                  } else {
                    Fluttertoast.showToast(msg: "不在参与时间内");
                  }
                },
              );
            }));
  }
}
