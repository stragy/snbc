import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bct_flutter/utils/log_util.dart';

import 'micro_class_detail_page.dart';

class MicroClassPage extends StatefulWidget {
  const MicroClassPage({
    super.key,
    required this.id,
  });

  final dynamic id;

  @override
  State<MicroClassPage> createState() => _MicroClassPageState();
}

class _MicroClassPageState extends State<MicroClassPage> {
  dynamic list;

  @override
  void initState() {
    super.initState();
    getCompany();
  }

  Future<void> getCompany() async {
    LogUtil.d(widget.id);
    FormData formData = FormData.fromMap({
      "company_id": widget.id,
    });
    await Request.getInstance().post("/companyVideoList", (data) async {
      setState(() {
        list = data;
      });
    }, params: formData);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(
            list != null ? list.length : 0,
            (index) => StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 2,
              child: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(AppColors.TEXT_WHITE),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Image.network(
                            list[index]['video_img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              list[index]['video_title'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(AppColors.TEXT_BLACK)),
                            )),
                        Container(
                            margin:
                                EdgeInsets.only(top: 5, bottom: 10, left: 5),
                            child: Text('主讲：${list[index]['video_desc']}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(AppColors.TEXT_HINT)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis))
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MicroClassifyDetailPage(id: list[index]['id'])));
                },
              ),
            ),
          ),
        ));
  }
}
