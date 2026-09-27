import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/course_classify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CourseClassifyDetailPage extends StatefulWidget {
  const CourseClassifyDetailPage({
    super.key,
    required this.id,
  });

  final dynamic id;

  @override
  State<CourseClassifyDetailPage> createState() =>
      _CourseClassifyDetailPageState();
}

class _CourseClassifyDetailPageState extends State<CourseClassifyDetailPage> {
  final bool _isFullscreen = false;
  dynamic data;
  dynamic videoUrl;
  dynamic list;
  bool ismore = false;
  VideoPlayerController? controller;
  Future<void>? future;

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  Future<void> getDetail() async {
    FormData formData = FormData.fromMap({
      "course_id": widget.id,
    });
    await Request.getInstance().post("/courseDetail", (data) async {
      if (data['video'] != null && data['video'].length > 0) {
        this.data = data['video'];
        controller = VideoPlayerController.networkUrl(
            Uri.parse(this.data[0]['video_url'] ?? ''));
        future = controller!.initialize();
      }
      list = data["course"];
      if (list != null && list.length == 0) list = null;
      setState(() {});
    }, params: formData);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _isFullscreen
            ? PreferredSize(
                preferredSize: const Size.fromHeight(0), child: AppBar())
            : AppBar(
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
                title: const Text('详情'),
                backgroundColor: Color(AppColors.APP_THEME),
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                titleSpacing: NavigationToolbar.kMiddleSpacing,
                toolbarOpacity: 1.0,
                bottomOpacity: 1.0,
                primary: true,
              ),
        body: ListView(
          children: [
            data != null
                ? Container(
                    height: 220,
                    alignment: Alignment.center,
                    child: controller != null
                        ? Chewie(
                            controller: ChewieController(
                                videoPlayerController: controller!,
                                aspectRatio: 16 / 9,
                                autoPlay: true,
                                looping: true))
                        : const SizedBox(),
                  )
                : const SizedBox(),
            // data != null ? playVideo() : Text(""),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(list != null ? list[0]['course_title'] ?? "" : "",
                  style: TextStyle(
                      color: Color(AppColors.TEXT_BLACK), fontSize: 16),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
                margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
                child: Text(
                    list != null
                        ? "主讲人：${list[0]['course_lecturer'] ?? ""}"
                        : "主讲人：暂无",
                    style: TextStyle(
                        fontSize: 15, color: Color(AppColors.Text_GRAY)),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
            Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 5, right: 10, bottom: 10),
              child: Text(
                  list != null
                      ? ismore
                          ? "简介：${list[0]['course_introduction'] ?? ""}"
                          : (list[0]['course_introduction']
                                          ?.toString()
                                          .length ??
                                      0) >
                                  40
                              ? "简介：${list[0]['course_introduction'].toString().substring(0, 39)}"
                              : "简介：${list[0]['course_introduction'] ?? ""}"
                      : "简介：暂无",
                  style: TextStyle(
                      color: Color(AppColors.TEXT_HINT), fontSize: 14),
                  softWrap: true,
                  maxLines: 50,
                  overflow: TextOverflow.ellipsis),
            ),
            InkWell(
              child: Image.network(
                ismore
                    ? "http://snbc.zglcwl.com/Public/fontImages/more_img.png"
                    : "http://snbc.zglcwl.com/Public/fontImages/more_img1.png",
                width: 8,
                height: 12,
              ),
              onTap: () {
                setState(() {
                  ismore = !ismore;
                });
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: list != null && list.length > 0 ? 6 : 0,
              color: const Color(0xfff5f5f5),
            ),
            // list != null && list.length > 0
            //     ? InkWell(
            //         child: Container(
            //           padding: EdgeInsets.only(top: 10, bottom: 10),
            //           color: Colors.white,
            //           child: Text(
            //             '查看课程目录',
            //             style: TextStyle(
            //                 color: Color(AppColors.TEXT_BLACK), fontSize: 17),
            //             softWrap: true,
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         onTap: () {
            //           print(data);
            //           // this.pushPage(FlutterDownloaderDemo());
            //           this.pushPage(CataloguePage(list: data));
            //         },
            //       )
            //     : SizedBox(),
            Container(
              height: list != null && list.length > 0 ? 6 : 0,
              margin: const EdgeInsets.only(bottom: 10),
              color: const Color(0xfff5f5f5),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list != null && list.length > 0 ? list.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: CourseClassifyWidget(data: list[index]),
                    onTap: () {
                      pushPage(CourseClassifyDetailPage(
                          id: list[index]['course_id']));
                    },
                  );
                })
          ],
        ));
  }

  void pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
