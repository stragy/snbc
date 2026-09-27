import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef CancelCallback = void Function();
typedef ConfirmCallback = void Function();
Future<void> chooseDialogTemplate({
  required BuildContext context,
  String? title,
  required Widget contentWidget,
  String cancelText = '取消',
  String confirmText = '确认',
  int cancelColor = AppColors.Text_GRAY,
  int confirmColor = AppColors.APP_THEME_LIGHT,
  bool confirmNotPop = false,
  CancelCallback? cancelCallback,
  ConfirmCallback? confirmCallBack,
}) async {
  List<Widget> getContentList(context1) {
    List<Widget> widgetList = [];
    if (title != null) {
      widgetList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(40),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: "familyFontStyle",
            color: Color(AppColors.BLACK),
            fontSize: ScreenUtil().setSp(36),
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
    widgetList.addAll([
      Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(36),
            bottom: ScreenUtil().setWidth(36),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: contentWidget,
      ),
      Container(
        height: ScreenUtil().setWidth(2),
        width: ScreenUtil().setWidth(562),
        color: Color(AppColors.TEXT_E5),
      ),
      Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                cancelCallback?.call();
                Navigator.pop(context1);
              },
              child: Container(
                height: ScreenUtil().setWidth(90),
                alignment: Alignment.center,
                child: Text(
                  cancelText,
                  style: TextStyle(
                    color: Color(cancelColor),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(90),
            width: ScreenUtil().setWidth(2),
            color: Color(AppColors.TEXT_E5),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (confirmNotPop == false) Navigator.pop(context1);
                  confirmCallBack?.call();
                },
                child: Container(
                  height: ScreenUtil().setWidth(90),
                  alignment: Alignment.center,
                  child: Text(
                    confirmText,
                    style: TextStyle(
                      color: Color(confirmColor),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              )),
        ],
      )
    ]);
    return widgetList;
  }

  // 释放对象使用的资源
  showDialog<Null>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context1) {
      return SimpleDialog(
        // 手势处理事件
        backgroundColor: Colors.transparent,
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: SafeArea(
                child: Center(
                    child: Container(
              width: ScreenUtil().setWidth(562),
              decoration: BoxDecoration(
                color: Color(AppColors.TEXT_WHITE),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(12))),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: getContentList(context1),
              ),
            ))),
          ),
        ],
      );
    },
  );
}
