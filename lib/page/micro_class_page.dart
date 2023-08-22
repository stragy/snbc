import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/page/course_classify_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'micro_class_detail_page.dart';

class MicroClassPage extends StatefulWidget {
  MicroClassPage({
    @required this.id,
  });

  var id;

  @override
  _MicroClassPageState createState() => _MicroClassPageState(id: id);
}

class _MicroClassPageState extends State<MicroClassPage> {
  _MicroClassPageState({
    @required this.id,
  });

  var id;
  var list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompany();
  }

  getCompany() async {
    print(id);
    FormData formData = new FormData.fromMap({
      "company_id": id,
    });
    await Request.getInstance().post("/companyVideoList", (data) async {
      list = data;
      setState(() {});
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: list != null ? list.length : 0,
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          itemBuilder: (BuildContext context, int index) => GestureDetector(child: new Container(
              decoration: new BoxDecoration(
                color: Color(AppColors.TEXT_WIT), // 底色
                //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Image.network(
               list[index]['video_img'],
                      fit: BoxFit.cover,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Container(
                      child:  Text(
                        list[index]['video_title'],
                        style: TextStyle(
                            fontSize: 14, color: Color(AppColors.TEXT_BLACK)),
                      )           ,  margin: EdgeInsets.only(left: 5)),
                  Container(
                      child: Text('主讲：${list[index]['video_desc']}',
                          style: TextStyle(
                              fontSize: 12, color: Color(AppColors.TEXT_HINT)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      margin: EdgeInsets.only(top: 5, bottom: 10,left: 5))
                ],
              )),onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MicroClassifyDetailPage(id: list[index]['id'],)));
          },),
          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ));
  }
}
