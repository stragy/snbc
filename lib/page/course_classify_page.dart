import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/course_classify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CourseClassifyPage extends StatefulWidget {
  CourseClassifyPage({
    @required this.classa,
  });

  var classa;

  @override
  _CourseClassifyPageState createState() =>
      _CourseClassifyPageState();
}

class _CourseClassifyPageState extends State<CourseClassifyPage> {


  EasyRefreshController _refreshController = EasyRefreshController();

  var list;
  var keyword = "";
  int begin = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArtile();
  }

  getArtile() async {
    list = null;
    if (widget.classa == "全部") widget.classa = "";
    FormData formData = new FormData.fromMap({
      "begin": begin,
      "end": begin+20,
      "class": widget.classa,
      "keyword": keyword,
    });
    await Request.getInstance().post("/course", (data) async {
      list = data['course'];
if(mounted)
      setState(() {});
      _refreshController.finishRefresh(success: true);
      _refreshController.finishLoad(
          success: true, noMore: list.length % 20 != 0);
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
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
          getArtile();
        },
        onRefresh: () {
          begin = 0;

          getArtile();
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
