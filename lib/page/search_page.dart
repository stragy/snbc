import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/course_classify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    @required this.keyWord,
  });

  var keyWord;

  @override
  _SearchPageState createState() => _SearchPageState(keyWord: keyWord);
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState({
    @required this.keyWord,
  });

  EasyRefreshController _refreshController = EasyRefreshController();

  var keyWord;
  var list;
  var begin=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourse();
  }

  getCourse() {
    FormData formData = new FormData.fromMap({
      "begin": begin,
      "end": begin+20,
      "keyword": keyWord,
    });
    Request.getInstance().post("/course", (data) async {
      list = data['course'];
      setState(() {});
      _refreshController.finishRefresh(success: true);
      _refreshController.finishLoad(
          success: true, noMore: list.length % 20 != 0);
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            backgroundColor: Color(0xfffffffff),
            appBar: AppBar(
              elevation: 0,
              //去掉Appbar底部阴影
              leading: IconButton(
                  icon:Image.network(
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
              backgroundColor: Color(AppColors.APP_ThEME),
              centerTitle: true,
              brightness: Brightness.dark,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              toolbarOpacity: 1.0,
              bottomOpacity: 1.0,
              primary: true,
            ),
            body: MediaQuery.removeViewPadding(
                removeTop: true,
                context: context,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: EasyRefresh(
                    header: MaterialHeader(),
                    footer: MaterialFooter(),
                    controller: _refreshController,
                    enableControlFinishRefresh: true,
                    enableControlFinishLoad: true,
                    child: ListView.builder(
                        itemCount: list != null ? list.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return CourseClassifyWidget(data: list[index]);
                        }),
                    onLoad: () {
                      begin++;
                      getCourse();
                    },
                    onRefresh: () {
                      begin = 0;

                      getCourse();
                    },
                  ),
                )));
  }
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
