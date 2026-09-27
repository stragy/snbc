import 'package:bct_flutter/common/ads_config.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/widget/course_classify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'course_classify_detail_page.dart';

class CourseClassifyPage extends StatefulWidget {
  const CourseClassifyPage({
    super.key,
    required this.classa,
  });

  final dynamic classa;

  @override
  State<CourseClassifyPage> createState() => _CourseClassifyPageState();
}

class _CourseClassifyPageState extends State<CourseClassifyPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  dynamic list;
  String keyword = "";
  int begin = 0;
  List<int> feedAdList = [];

  /// 信息流广告位列表（轮换使用）
  final List<String> feedIdList = [AdsConfig.feedId];

  @override
  void initState() {
    super.initState();
    getArtile();
    // Web 平台不支持插件，不注册广告事件监听
    if (AdsConfig.isAdSupported) {
      setAdEvent();
    }
  }

  /// 获取 Feed 信息流列表

  int currentPosition = 0;

  Future<void> getArtile() async {
    list = null;
    var classValue = widget.classa;
    if (classValue == "全部") classValue = "";
    FormData formData = FormData.fromMap({
      "begin": begin,
      "end": begin + 20,
      "class": classValue,
      "keyword": keyword,
    });
    await Request.getInstance().post("/course", (data) async {
      list = data['course'];
      if (mounted) setState(() {});
      _refreshController.refreshCompleted();
      if (list != null && list.length % 20 != 0) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }, params: formData);
    // 课程列表加载后尝试加载信息流广告（未配置广告位时内部自动跳过）
    getFeedAdList();
  }

  // 加载信息流广告
  Future<void> getFeedAdList() async {
    try {
      // Web 平台不支持插件 / 广告位 ID 未配置时跳过加载（安全降级，列表不展示广告）
      if (!AdsConfig.isAdSupported) return;
      if (feedIdList.isEmpty || feedIdList.first.isEmpty) return;
      int feedIdIndex = feedAdList.length ~/ 3 % feedIdList.length;
      debugPrint('feedIdIndex:$feedIdIndex');
      List<int> adResultList = await FlutterPangleAds.loadFeedAd(
        feedIdList[feedIdIndex],
        count: 3,
      );
      feedAdList.addAll(adResultList);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SmartRefresher(
        header: ClassicHeader(),
        footer: ClassicFooter(),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        child: ListView.builder(
            itemCount: list != null ? list.length : 0,
            itemBuilder: (BuildContext context, int index) {
              if (index % 10 == 4) {
                int adIndex = index ~/ 10;
                debugPrint('adIndex==================:$adIndex');
                if (adIndex >= feedAdList.length) {
                  return Container();
                }

                int adId = feedAdList[adIndex];
                return AdFeedWidget(
                  posId: '$adId',
                  height: 75,
                  show: true,
                );
              }
              return InkWell(
                child: CourseClassifyWidget(
                  data: list[index],
                  onclick: false,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text("观看视频查看详情"),
                        actions: [
                          TextButton(
                            child: const Text("取消"),
                            onPressed: () {
                              Navigator.of(context).pop(); // 关闭弹框
                            },
                          ),
                          TextButton(
                            child: const Text("确定"),
                            onPressed: () {
                              Navigator.of(context).pop(); // 关闭弹框
                              currentPosition = index;
                              showRewardVideoAd();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }),
        onLoading: () async {
          begin++;
          await getArtile();
        },
        onRefresh: () async {
          begin = 0;
          await getArtile();
        },
      ),
    );
  }

  /// 展示激励视频广告（观看完毕后解锁课程详情）
  Future<void> showRewardVideoAd() async {
    try {
      bool result = await FlutterPangleAds.showRewardVideoAd(
        AdsConfig.rewardVideoUnlockId,
        customData: 'customData',
        userId: 'userId',
      );
      debugPrint("展示激励视频广告${result ? '成功' : '失败'}");
      // 广告展示失败时兜底放行，避免用户无法进入详情
      if (!result) {
        pushDetail(currentPosition);
      }
    } on PlatformException catch (e) {
      debugPrint(
          "展示激励视频广告失败 code:${e.code} msg:${e.message} details:${e.details}");
      pushDetail(currentPosition);
    }
  }

  /// 进入课程详情
  void pushDetail(int index) {
    if (!mounted) return;
    if (list == null || index >= list.length) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CourseClassifyDetailPage(id: list[index]['course_id'])));
  }

  /// 设置广告监听
  Future<void> setAdEvent() async {
    FlutterPangleAds.onEventListener((event) {
      debugPrint('adId:${event.adId} action:${event.action}');
      if ((event.action == AdEventAction.onAdError ||
              event.action == AdEventAction.onAdClosed) &&
          event.adId == AdsConfig.rewardVideoUnlockId) {
        // 激励播放完毕（或加载失败），进入课程详情
        pushDetail(currentPosition);
      }
    });
  }

  @override
  void dispose() {
    // 清理信息流广告，避免内存泄漏
    if (feedAdList.isNotEmpty) {
      FlutterPangleAds.clearFeedAd(feedAdList);
    }
    _refreshController.dispose();
    super.dispose();
  }
}
