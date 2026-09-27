import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class CourseClassifyWidget extends StatelessWidget {
  const CourseClassifyWidget({super.key, this.data, this.onclick = false});
  final dynamic data;
  final bool onclick;

  @override
  Widget build(BuildContext context) {
    return buildGoods(context);
  }

  Widget buildGoods(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                child: Image.network(
                  data['course_img'],
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(data['course_title'],
                        style: TextStyle(
                            color: Color(AppColors.TEXT_BLACK), fontSize: 14),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    child: Text(data['course_introduction'],
                        style: TextStyle(
                            color: Color(AppColors.TEXT_BLACK), fontSize: 12),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, top: 5),
                      child: Text("主讲：${data['course_lecturer']}",
                          style: TextStyle(
                              fontSize: 12, color: Color(AppColors.Text_GRAY)),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                ],
              ))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              height: 1,
              color: Color(AppColors.BG_EE),
            ),
          )
        ],
      ),
    );
  }

  void pushPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
