import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/model/banner_model.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/about_page.dart';
import 'package:bct_flutter/page/course_classify_detail_page.dart';
import 'package:bct_flutter/page/course_classify_page.dart';
import 'package:bct_flutter/page/search_page.dart';
import 'package:bct_flutter/page/widget/home_search_card.dart';
import 'package:bct_flutter/utils/ui_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pangle_ads/view/ad_banner_widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  TextEditingController _keywordTextEditingController = TextEditingController();
  FocusNode _focus = new FocusNode();
  var banner_images;
  List<BannerModel> mTabs = new List();
  TabController _tabController;

  int _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: mTabs.length);
    _tabController.addListener(() {
      setState(() => _selectedIndex = _tabController.index);
      print("liucheng-> ${_tabController.indexIsChanging}");
    });

    getCourse();
    getClass();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  // 轮播图
  getCourse() async {
    FormData formData = new FormData.fromMap({
      "begin": 0,
      "end": 20,
      "keyword": "",
    });
    await Request.getInstance().post("/course", (data) async {
      setState(() {
        banner_images = data['banner'];
      });
    }, params: formData);
  }

  getClass() async {
    FormData formData = new FormData.fromMap({
      "begin": 0,
      "end": 20,
      "keyword": "",
    });
    await Request.getInstance().post("/getClass", (data) async {
      mTabs = (data['course_class'] as List)
          .map((item) => BannerModel.fromJSON(item))
          .toList();
      mTabs.insert(0, new BannerModel(class_name: "全部"));
      setState(() {
        _tabController = TabController(vsync: this, length: mTabs.length);
      });
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
      children: [
      MediaQuery.removePadding(context: context, child:     Container(
          color: Color(AppColors.APP_ThEME),
          padding: EdgeInsets.only(right: 10, left: 10, top: 35,bottom: 5),
          child: HomeSearchCardWidget(
            elevation: 0,
            onTap: () {
            },
            onSubmitted: (String str) {
              FocusScope.of(context).unfocus();
            _keywordTextEditingController.text = '';
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage(keyWord:str)));
            },
            onChanged: (String str) {
            },
            textEditingController: _keywordTextEditingController,
            focusNode: _focus,
          ))),
        swiper(),
        AdBannerWidget(
          height: 75,
          posId: "953317270",
        ),

        PreferredSize(
            preferredSize: Size(double.infinity, 30),//设置高度为30
            child: Container(
              height: 35,
              margin: EdgeInsets.only(bottom: 10),
              child: TabBar(
                indicatorColor: Color(AppColors.APP_ThEME),
                labelColor: Color(AppColors.APP_ThEME),
                unselectedLabelColor: Color(AppColors.TEXT_BLACK),
                indicatorWeight: 2.0,
                isScrollable: true,
                unselectedLabelStyle: TextStyle(fontSize: 15),
                       labelPadding: EdgeInsetsDirectional.only(start: 20,end: 20),
                labelStyle: TextStyle(fontSize: 15),
                // indicator: MyUnderlineTabIndicator(borderSide:  BorderSide(width: 2.0, color: MyColorRes.primaryColor)),
                controller: _tabController,
                tabs: mTabs.map((value) {
                  return Text(value.class_name);
                }).toList(),
              )
            ))
       ,
        Expanded(child: TabBarView(
          controller: this._tabController,
          children: _buildPages(),
        ))

      ],
    ));
  }

  List<Widget> _buildPages() {
    List<Widget> pages = List();
    for (int i = 0; i < mTabs.length; i++) {
      Widget page = CourseClassifyPage(classa: mTabs[i].class_name);
      pages.add(page);
    }
    return pages;
  }

  Widget swiper() {

    return new Container(
      width: DeviceUtils.sreenWidth(context),
      height: DeviceUtils.sreenWidth(context) * 0.38,
      child: banner_images != null && banner_images.length > 0
          ? Swiper(
              itemBuilder: _swiperBuilder,
              itemCount: banner_images != null && banner_images.length > 0
                  ? banner_images.length
                  : 0,
              scrollDirection: Axis.horizontal,
              autoplay: true,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Color(AppColors.TEXT_HINT),
              activeColor: Color(AppColors.APP_ThEME),
              size: 7,
              activeSize: 7,
            )),
              // viewportFraction: 0.86,
              // scale: 0.92,
              onTap: (index) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseClassifyDetailPage(id: banner_images[index]['course_id'])));
              },
            )
          : SizedBox(),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Image.network(
        banner_images[index]['img'],
        fit: BoxFit.fill,
      ),
    ));
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
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
