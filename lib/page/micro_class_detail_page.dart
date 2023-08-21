// import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/course_classify_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'catalogue_page.dart';

class MicroClassifyDetailPage extends StatefulWidget {
  MicroClassifyDetailPage({
    @required this.id,
  });

  var id;

  @override
  _MicroClassifyDetailPageState createState() =>
      _MicroClassifyDetailPageState(id: id);
}

class _MicroClassifyDetailPageState extends State<MicroClassifyDetailPage> {
  _MicroClassifyDetailPageState({
    @required this.id,
  });

  var id;
  bool _isFullscreen = false;
  var data;
  var videoUrl;
  VideoPlayerController controller;
  Future future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  getDetail() async {
    FormData formData = new FormData.fromMap({
      "id": id,
    });
    await Request.getInstance().post("/companyVideo", (data) async {
      // if (data['video'] != null && data['video'].length > 0)
      //   this.data = data['video'];
      // list = data["course"];
      this.data = data;
      controller = VideoPlayerController.network(this.data['video_url']);
      future = controller.initialize();
      setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _isFullscreen
            ? PreferredSize(child: AppBar(), preferredSize: Size.fromHeight(0))
            : AppBar(
                elevation: 0,
                //去掉Appbar底部阴影
                leading: IconButton(
                    icon: CachedNetworkImage(
                      width: 11,
                      height: 19,
                      fit: BoxFit.fill,
                      imageUrl:
                          "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                automaticallyImplyLeading: true,
                title: Text('详情'),
                backgroundColor: Color(AppColors.APP_ThEME),
                centerTitle: true,
                brightness: Brightness.dark,
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
                    child: Chewie(
                        controller: ChewieController(
                            videoPlayerController: controller,
                            aspectRatio: 16 / 9,
                            autoPlay: true,
                            looping: true)),
                  )
                : SizedBox(),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(data != null ? data['video_title'] : "",
                  style: TextStyle(
                      color: Color(AppColors.TEXT_BLACK), fontSize: 16),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                child: Text(
                    data != null ? "主讲人：${data['video_lecturer']}" : "主讲人：暂无",
                    style: TextStyle(
                        fontSize: 15, color: Color(AppColors.Text_GRAY)),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
            Container(
              margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
              child: Text(data != null ? "简介：${data['video_desc']}" : "简介：暂无",
                  style: TextStyle(
                      color: Color(AppColors.TEXT_HINT), fontSize: 14),
                  softWrap: true,
                  maxLines: 50,
                  overflow: TextOverflow.ellipsis),
            ),
            // InkWell(
            //   child:
            //     CachedNetworkImage(
            //       width: 8,
            //       height: 12,
            //       imageUrl: ismore ?"http://snbc.zglcwl.com/Public/fontImages/more_img.png":"http://snbc.zglcwl.com/Public/fontImages/more_img1.png",
            //     ),
            //
            //     onTap: () {
            //     if (ismore)
            //       ismore = false;
            //     else
            //       ismore = true;
            //     setState(() {});
            //   },
            // ),
            // Container(
            //   margin: EdgeInsets.only(top: 10),
            //   height:   list != null && list.length > 0 ? 6:0,
            //   color: Color(0xfff5f5f5),
            // ),
            // list != null && list.length > 0 ?  InkWell(
            //   child: Container(
            //     padding: EdgeInsets.only(top: 10, bottom: 10),
            //     color: Colors.white,
            //     child: Text(
            //       '查看课程目录',
            //       style: TextStyle(
            //           color: Color(AppColors.TEXT_BLACK), fontSize: 17),
            //       softWrap: true,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            //   onTap: () {
            //     print(data);
            //     // this.pushPage(FlutterDownloaderDemo());
            //     this.pushPage(CataloguePage(list: data));
            //   },
            // ):SizedBox(),
            // Container(
            //   height:   list != null && list.length > 0 ? 6:0,
            //   margin: EdgeInsets.only(bottom: 10),
            //   color: Color(0xfff5f5f5),
            // ),
            // ListView.builder(
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     itemCount:
            //         list != null && list.length > 0 ? list.length : 0,
            //     itemBuilder: (BuildContext context, int index) {
            //       return CourseClassifyWidget(data: list[index]);
            //     })
          ],
        ));
  }

  void pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

// Widget playVideo() {
//   return AwsomeVideoPlayer(
//     data['video_url'],
//
//     /// 视频播放配置
//     playOptions: VideoPlayOptions(
//         seekSeconds: 10,
//         //左侧垂直手势调节视频亮度的单位（0～1之间，不能小于0，不能大于1）
//         brightnessGestureUnit: 0.05,
//         //右侧垂直手势调节视频音量的单位（0～1之间，不能小于0，不能大于1）
//         volumeGestureUnit: 0.05,
//         //横行手势调节视频进度的单位秒数
//         progressGestureUnit: 2000,
//         aspectRatio: 16 / 9,
//         loop: true,
//         autoplay: true,
//         allowScrubbing: true,
//         startPosition: Duration(seconds: 0)),
//
//     /// 自定义视频样式
//     videoStyle: VideoStyle(
//       /// 自定义视频暂停时视频中部的播放按钮
//       playIcon: Icon(
//         Icons.play_circle_outline,
//         size: 80,
//         color: Colors.white,
//       ),
//
//       /// 暂停时是否显示视频中部播放按钮
//       showPlayIcon: true,
//
//       videoLoadingStyle: VideoLoadingStyle(
//         /// 重写部分（二选一）
//         // 重写Loading的widget
//         // customLoadingIcon: CircularProgressIndicator(strokeWidth: 2.0),
//         // 重写Loading 下方的Text widget
//         // customLoadingText: Text("加载中..."),
//         /// 设置部分（二选一）
//         // 设置Loading icon 下方的文字
//         loadingText: "",
//         // 设置loading icon 下方的文字颜色
//         loadingTextFontColor: Colors.white,
//         // 设置loading icon 下方的文字大小
//         loadingTextFontSize: 20,
//       ),
//
//       /// 自定义顶部控制栏
//       videoTopBarStyle: VideoTopBarStyle(
//         show: !_isFullscreen ? false : true,
//         //是否显示
//         height: 30,
//         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         barBackgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
//         popIcon: Icon(
//           Icons.arrow_back_ios,
//           size: 25,
//           color: Colors.white,
//         ),
//       ),
//
//       /// 自定义底部控制栏
//       videoControlBarStyle: VideoControlBarStyle(
//         /// 自定义颜色
//         // barBackgroundColor: Colors.blue,
//
//         ///添加边距
//         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//
//         ///设置控制拦的高度，默认为30，如果图标设置过大但是高度不够就会出现图标被裁剪的现象
//         height: 30,
//
//         /// 更改进度栏的播放按钮
//         playIcon: Icon(Icons.play_arrow, color: Colors.white, size: 16),
//
//         /// 更改进度栏的暂停按钮
//         pauseIcon: Icon(
//           Icons.pause,
//           color: Colors.white,
//           size: 16,
//         ),
//
//         /// 更改进度栏的快退按钮
//         rewindIcon: Icon(
//           Icons.replay_10,
//           size: 16,
//           color: Colors.white,
//         ),
//
//         /// 更改进度栏的快进按钮
//         forwardIcon: Icon(
//           Icons.forward_10,
//           size: 16,
//           color: Colors.white,
//         ),
//
//         /// 更改进度栏的全屏按钮
//         fullscreenIcon: Icon(
//           Icons.fullscreen,
//           size: 20,
//           color: Colors.white,
//         ),
//
//         /// 更改进度栏的退出全屏按钮
//         fullscreenExitIcon: Icon(
//           Icons.fullscreen_exit,
//           size: 20,
//           color: Colors.red,
//         ),
//
//         /// 决定控制栏的元素以及排序，示例见上方图3
//         itemList: [
//           "rewind",
//           "play",
//           "forward",
//           "position-time", //当前播放时间
//           "progress", //线条形进度条（与‘basic-progress’二选一）
//           // "basic-progress",//矩形进度条（与‘progress’二选一）
//           "duration-time", //视频总时长
//           // "time",//格式：当前时间/视频总时长
//           "fullscreen"
//         ],
//       ),
//     ),
//
//     /// 视频暂停回调
//     onpause: (value) {
//       print("video paused");
//       setState(() {
//         // isPlaying = false;
//       });
//     },
//
//     /// 视频播放回调
//     onplay: (value) {
//       print("video played");
//       setState(() {
//         // isPlaying = true;
//       });
//     },
//
//     /// 视频播放结束回调
//     onended: (value) {
//       print("video ended");
//     },
//
//     /// 视频播放进度回调
//     /// 可以用来匹配字幕
//     ontimeupdate: (value) {
//       // print("timeupdate ${value}");
//       // var position = value.position.inMilliseconds / 1000;
//       //根据 position 来判断当前显示的字幕
//     },
//
//     onprogressdrag: (position, duration) {
//       print("进度条拖拽的时间节点： ${position}");
//       print("进度条总时长： ${duration}");
//     },
//
//     onvolume: (value) {
//       print("onvolume ${value}");
//     },
//
//     onbrightness: (value) {
//       print("onbrightness ${value}");
//     },
//
//     onfullscreen: (fullscreen) {
//       print("is fullscreen $fullscreen");
//       setState(() {
//         _isFullscreen = fullscreen;
//       });
//     },
//
//     /// 顶部控制栏点击返回按钮
//     onpop: (value) {
//       print("返回上一页");
//       setState(() {
//         _isFullscreen = false;
//       });
//     },
//   );
// }
}
