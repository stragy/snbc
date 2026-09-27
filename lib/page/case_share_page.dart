import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/case_share_detail_page.dart';
import 'package:flutter/material.dart';

class CaseSharePage extends StatefulWidget {
  const CaseSharePage({super.key, required this.id});

  final dynamic id;

  @override
  State<CaseSharePage> createState() => _CaseSharePageState();
}

class _CaseSharePageState extends State<CaseSharePage> {
  List<dynamic> _list = [];

  @override
  void initState() {
    super.initState();
    getCompany();
  }

  Future<void> getCompany() async {
    debugPrint('company_id: ${widget.id}');
    final formData = FormData.fromMap({
      "company_id": widget.id,
    });
    await Request.getInstance().post("/diseaseShareList", (data) async {
      _list = (data as List);
      if (mounted) setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              _list[index]['title'],
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(AppColors.TEXT_BLACK)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10, right: 15),
                              child: Text(
                                "${_list[index]['pv']}人浏览",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(AppColors.TEXT_HINT)),
                              )),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8, left: 15),
                          child: Text(
                            "医生：${_list[index]['doc_name']}  ${_list[index]['department']}  ${_list[index]['doc_title']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(AppColors.ICON_GRAY)),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 8, left: 15, bottom: 10),
                          child: Text(
                            "医院：${_list[index]['hospital']}",
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
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CaseShareDetailPage(id: _list[index]['id'])));
                },
              );
            }));
  }
}
