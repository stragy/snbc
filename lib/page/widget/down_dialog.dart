import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

 // ignore: non_constant_identifier_names
Future<String> DownDialog(BuildContext context, String path, String localpath, String name, String con) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        // 手势处理事件
        backgroundColor: Colors.transparent,
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: SafeArea(
                child: Center(
                    child: Container(
              width: ScreenUtil().setWidth(622),
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setWidth(30)),
              decoration: BoxDecoration(
                color: Color(AppColors.TEXT_WHITE),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(20))),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      '发现新版本',
                      style: TextStyle(
                        color: Color(AppColors.APP_THEME_LIGHT),
                        fontSize: ScreenUtil().setSp(44),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30),
                        bottom: ScreenUtil().setWidth(10)),
                    child: Text(
                      '最新版本V$name',
                      style: TextStyle(
                        color: Color(AppColors.TEXT_HINT),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '更新内容:',
                      style: TextStyle(
                        color: Color(AppColors.BLACK),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(12)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      con,
                      maxLines: 6,
                      style: TextStyle(
                        color: Color(AppColors.TEXT_HINT),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(206),
                        height: ScreenUtil().setWidth(68),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(AppColors.TEXT_HINT),
                          ),
                          color: Color(AppColors.TEXT_HINT),
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppColors.TEXT_WHITE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '以后再说',
                              style: TextStyle(
                                color: Color(AppColors.Text_GRAY),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setHeight(23),
                            right: ScreenUtil().setHeight(23)),
                        width: ScreenUtil().setWidth(206),
                        height: ScreenUtil().setWidth(68),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppColors.APP_THEME),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                          onPressed: () async {
                            final status = await Permission.storage.request();
                            if (!context.mounted) return;
                            if (status.isGranted) {
                              DataUtils().downloadFile(path, localpath);
                              Navigator.pop(context);
                            } else {
                              DataUtils.ShowTos("请先允许权限");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '立即下载',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(28),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))),
          ),
        ],
      );
    },
  );
  return ""; // Return empty string as placeholder
}
