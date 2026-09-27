import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/banner_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/course_classify_detail_page.dart';
import 'package:bct_flutter/page/course_classify_page.dart';
import 'package:bct_flutter/page/search_page.dart';
import 'package:bct_flutter/page/widget/home_search_card.dart';
import 'package:bct_flutter/utils/event_bus.dart';
import 'package:bct_flutter/utils/ui_util.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final TextEditingController _keywordTextEditingController =
      TextEditingController();
  final FocusNode _focus = FocusNode();
  List<dynamic>? bannerImages;
  List<BannerModel> mTabs = <BannerModel>[];
  TabController? _tabController;
  var bus = EventBus();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: mTabs.length);
    _tabController!.addListener(() {
      setState(() {});
      debugPrint('liucheng-> ${_tabController!.indexIsChanging}');
    });

    // 测试网络连接
    debugPrint('🚀 HomeView 初始化开始');
    _testAndLoadData();
  }

  Future<void> _testAndLoadData() async {
    // 直接加载数据，不做额外网络测试（避免不必要的请求）
    getCourse();
    getClass();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  // 轮播图
  Future<void> getCourse() async {
    try {
      FormData formData = FormData.fromMap({
        "begin": 0,
        "end": 20,
        "keyword": "",
      });
      debugPrint('🔍 开始请求课程轮播图数据...');
      await Request.getInstance().post("/course", (data) async {
        debugPrint('✅ 课程轮播图数据请求成功');
        debugPrint('📊 Banner数据: ${data['banner']}');
        if (!mounted) return;
        setState(() {
          bannerImages = data['banner'];
        });
      }, params: formData, errorCallBack: (error) {
        debugPrint('❌ 课程轮播图请求失败: $error');
      }, silent: true);
    } catch (e) {
      debugPrint('❌ getCourse 异常: $e');
    }
  }

  Future<void> getClass() async {
    try {
      FormData formData = FormData.fromMap({
        "begin": 0,
        "end": 20,
        "keyword": "",
      });
      debugPrint('🔍 开始请求课程分类数据...');
      await Request.getInstance().post("/getClass", (data) async {
        debugPrint('✅ 课程分类数据请求成功');
        debugPrint('📊 分类数量: ${data['course_class']?.length ?? 0}');
        mTabs = (data['course_class'] as List)
            .map((item) => BannerModel.fromJson(item))
            .toList();
        mTabs.insert(0, BannerModel(className: "全部"));
        if (mounted) {
          setState(() {
            _tabController = TabController(vsync: this, length: mTabs.length);
          });
        }
      }, params: formData, errorCallBack: (error) {
        debugPrint('❌ 课程分类请求失败: $error');
      }, silent: true);
    } catch (e) {
      debugPrint('❌ getClass 异常: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            MediaQuery.removePadding(
                context: context,
                child: Container(
                    color: Color(AppColors.APP_THEME),
                    padding: EdgeInsets.only(
                        right: 10, left: 10, top: 35, bottom: 5),
                    child: HomeSearchCardWidget(
                      elevation: 0,
                      onTap: () {},
                      onSubmitted: (String str) {
                        FocusScope.of(context).unfocus();
                        _keywordTextEditingController.text = '';
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchPage(keyWord: str)));
                      },
                      onChanged: (String str) {},
                      textEditingController: _keywordTextEditingController,
                      focusNode: _focus,
                    ))),
            swiper(),
            PreferredSize(
                preferredSize: Size(double.infinity, 30), //设置高度为30
                child: Container(
                    height: 35,
                    margin: EdgeInsets.only(bottom: 10),
                    child: TabBar(
                      indicatorColor: Color(AppColors.APP_THEME),
                      labelColor: Color(AppColors.APP_THEME),
                      unselectedLabelColor: Color(AppColors.TEXT_BLACK),
                      indicatorWeight: 2.0,
                      isScrollable: true,
                      unselectedLabelStyle: TextStyle(fontSize: 15),
                      labelPadding:
                          EdgeInsetsDirectional.only(start: 20, end: 20),
                      labelStyle: TextStyle(fontSize: 15),
                      controller: _tabController,
                      tabs: mTabs.map((value) {
                        return Text(value.className ?? '');
                      }).toList(),
                    ))),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: _buildPages(),
            ))
          ],
        ));
  }

  List<Widget> _buildPages() {
    List<Widget> pages = <Widget>[];
    for (int i = 0; i < mTabs.length; i++) {
      Widget page = CourseClassifyPage(classa: mTabs[i].className ?? '');
      pages.add(page);
    }
    return pages;
  }

  Widget swiper() {
    return SizedBox(
      width: DeviceUtils.sreenWidth(context),
      height: DeviceUtils.sreenWidth(context) * 0.38,
      child: bannerImages != null && bannerImages!.isNotEmpty
          ? Swiper(
              itemBuilder: _swiperBuilder,
              itemCount: bannerImages?.length ?? 0,
              scrollDirection: Axis.horizontal,
              autoplay: true,
              pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                color: Color(AppColors.TEXT_HINT),
                activeColor: Color(AppColors.APP_THEME),
                size: 7,
                activeSize: 7,
              )),
              onTap: (index) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseClassifyDetailPage(
                            id: bannerImages![index]['course_id'])));
              },
            )
          : SizedBox(),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Image.network(
        bannerImages![index]['img'],
        fit: BoxFit.fill,
      ),
    ));
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 34;

  @override
  double get minExtent => 34;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
