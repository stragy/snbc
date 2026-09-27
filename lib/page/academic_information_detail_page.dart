import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/article_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AcademicInformationDetailPage extends StatefulWidget {
  const AcademicInformationDetailPage({
    super.key,
    required this.id,
  });

  final dynamic id;

  @override
  State<AcademicInformationDetailPage> createState() =>
      _AcademicInformationDetailState();
}

// Widget playVideo() {
//   return AwsomeVideoPlayer(
//     data[0]['video_url'],
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

class _AcademicInformationDetailState
    extends State<AcademicInformationDetailPage> {
  ArticleModel model = ArticleModel();

  _AcademicInformationDetailState();
  final EventBus bus = EventBus();

  @override
  void initState() {
    super.initState();
    getArtile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          model.articleTitle ?? "文章详情",
        ),
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
          Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Text(
              model.articleTitle ?? "",
              style: TextStyle(fontSize: 18, color: Color(AppColors.BLACK)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Text(
              model.articleLecturer ?? "",
              style: TextStyle(fontSize: 16, color: Color(AppColors.Text_GRAY)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Text(
              model.addTime != null
                  ? "发布日期：${fromNow(int.parse(model.addTime!))}"
                  : "",
              style: TextStyle(fontSize: 14, color: Color(AppColors.Text_GRAY)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Text(
              model.articleContent ?? "",
              style: TextStyle(
                fontSize: 16,
                color: Color(AppColors.Text_GRAY),
              ),
              maxLines: 100,
            ),
          )
        ],
      ),
    );
  }

  String fromNow(int timeStamp) {
    /// 因为dart里面并没有实现时区的设置，只能手动设置了

    int now = DateTime.now().millisecondsSinceEpoch + 8 * 3600000;
    double distance = (now - timeStamp) / 60000;
    // 大于24小时就直接显示日期
    if (distance > 24 * 60) {
      DateTime time =
          DateTime.fromMillisecondsSinceEpoch((timeStamp + 8 * 3600) * 1000);
      return DateFormat('yyyy/MM/dd HH:mm').format(time);
    }

    if (distance > 60 && distance < 24 * 60) {
      return '${(distance / 60).toStringAsFixed(0)}小时前';
    }

    if (distance < 60 && distance > 1) {
      return '${distance.toStringAsFixed(0)}分钟前';
    } else {
      DateTime time =
          DateTime.fromMillisecondsSinceEpoch((timeStamp + 8 * 3600) * 1000);
      return DateFormat('yyyy/MM/dd HH:mm').format(time);
    }
  }

  Future<void> getArtile() async {
    FormData formData = FormData.fromMap({
      "article_id": widget.id,
    });
    await Request.getInstance().post("/articleDetail", (data) async {
      model = ArticleModel.fromJson(data);
      setState(() {});
    }, params: formData);
  }
}
