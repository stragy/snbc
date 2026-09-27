import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/course_classify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'course_classify_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.keyWord,
  });

  final String keyWord;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<dynamic> list = [];
  int begin = 0;

  @override
  void initState() {
    super.initState();
    getCourse();
  }

  Future<void> getCourse() async {
    FormData formData = FormData.fromMap({
      "begin": begin,
      "end": begin + 20,
      "keyword": widget.keyWord,
    });
    await Request.getInstance().post("/course", (data) async {
      list = (data['course'] as List?) ?? [];
      setState(() {});
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
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0,
          //去掉Appbar底部阴影
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
          automaticallyImplyLeading: true,
          title: Text('搜索'),
          backgroundColor: Color(AppColors.APP_THEME),
          centerTitle: true,
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          toolbarOpacity: 1.0,
          bottomOpacity: 1.0,
          primary: true, systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: MediaQuery.removeViewPadding(
            removeTop: true,
            context: context,
            child: Container(
              margin: EdgeInsets.only(top: 10),
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
                        child: CourseClassifyWidget(data: list[index]),
                        onTap: () {
                          pushPage(CourseClassifyDetailPage(
                              id: list[index]['course_id']));
                        },
                      );
                    }),
                onLoading: () async {
                  begin++;
                  await getCourse();
                },
                onRefresh: () async {
                  begin = 0;
                  await getCourse();
                },
              ),
            )));
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
