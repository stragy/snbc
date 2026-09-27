import 'package:bct_flutter/common/ads_config.dart';
import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/article_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/academic_information_detail_page.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//学术资料
class AcademicInformationView extends StatefulWidget {
  const AcademicInformationView({super.key});

  @override
  State<AcademicInformationView> createState() =>
      _AcademicInformationViewState();
}

class _AcademicInformationViewState extends State<AcademicInformationView> {
  int begin = 0;
  List<ArticleModel> list = <ArticleModel>[];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final bus = EventBus();

  @override
  void initState() {
    super.initState();
    getArtile();
  }

  Future<void> getArtile() async {
    FormData formData = FormData.fromMap({
      "begin": begin,
      "end": 20,
    });
    await Request.getInstance().post("/article", (data) async {
      setState(() {
        list = (data['article'] as List)
            .map((item) => ArticleModel.fromJson(item))
            .toList();
      });
      _refreshController.refreshCompleted();
      if (list.length % 20 != 0) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }, params: formData);
  }

  /// 展示激励视频广告
  Future<void> showRewardVideoAd() async {
    try {
      bool result = await FlutterPangleAds.showRewardVideoAd(
        AdsConfig.rewardVideoId,
        customData: 'customData',
        userId: 'userId',
      );
      debugPrint("展示激励视频广告${result ? '成功' : '失败'}");
    } on PlatformException catch (e) {
      debugPrint(
          "展示激励视频广告失败 code:${e.code} msg:${e.message} details:${e.details}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('学术资料'),
        backgroundColor: Color(AppColors.APP_THEME),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light, // 替换 brightness
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        primary: true,
        actions: [
          // Web 平台不支持穿山甲插件，隐藏广告入口
          if (AdsConfig.isAdSupported)
            InkWell(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Text("激励广告"),
                alignment: Alignment.center,
              ),
              onTap: () async {
                await showRewardVideoAd();
              },
            )
        ],
      ),
      body: Column(
        children: [
          if (AdsConfig.isAdSupported)
            AdBannerWidget(
              width: 300,
              height: 75,
              interval: 30,
              show: true,
              posId: AdsConfig.bannerId,
            ),
          Expanded(
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
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                list[index].articleImg ?? '',
                                width: 100,
                                height: 70,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(list[index].articleTitle ?? '',
                                        style: TextStyle(
                                            color: Color(AppColors.TEXT_BLACK),
                                            fontSize: 16),
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "主讲：${list[index].articleLecturer}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Color(AppColors.Text_GRAY)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                AppAssets.eyes,
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              Text("${list[index].articleSee}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(
                                                          AppColors.Text_GRAY)))
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: const Divider(
                              height: 1,
                              color: Color(AppColors.BG_EE),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      pushPage(AcademicInformationDetailPage(
                          id: list[index].articleId));
                    },
                  );
                }),
            onRefresh: () async {
              begin = 0;
              await getArtile();
            },
            onLoading: () async {
              begin++;
              await getArtile();
            },
          )),
        ],
      ),
    );
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
