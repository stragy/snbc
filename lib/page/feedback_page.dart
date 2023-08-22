import 'dart:convert';
import 'dart:typed_data';

import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController contentController = TextEditingController();
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              elevation: 0,
              //去掉Appbar底部阴影
              leading: IconButton(
                  icon:  Image.network(
                    "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
                    width: 11,
                    height: 19,
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: true,
              title: Text('意见反馈'),
              backgroundColor: Color(AppColors.APP_ThEME),
              centerTitle: true,
              brightness: Brightness.dark,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              toolbarOpacity: 1.0,
              bottomOpacity: 1.0,
              primary: true,
            ),
            floatingActionButton: GestureDetector(
              child: Container(
                height: 40,
                margin: EdgeInsets.only(left: 30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(AppColors.APP_ThEME),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Text(
                  '提交',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                subject();
              },
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      "您的意见",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(AppColors.BLACK),
                      ),
                    )),
                Divider(
                  height: 1,
                  color: Color(AppColors.BG_EE),
                ),
                Container(
                    height: 150,
                    child: new TextField(
                      // 控制器用于获取输入的内容
                      controller: contentController,
                      // 键盘格式
                      keyboardType: TextInputType.number,
                      // 光标颜色
                      cursorColor: Color(AppColors.APP_ThEME),
                      // 键盘动作按钮，如“下一步”
                      textInputAction: TextInputAction.next,
                      // 键盘动作按钮点击之后执行的代码：

                      //光标切换到指定的输入框
                      onEditingComplete: () {},
                      // 文本样式
                      style: new TextStyle(color: Color(AppColors.BLACK)),
                      decoration: InputDecoration(
                          // 输入框边框
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(25),
                              top: ScreenUtil().setHeight(10)),
                          // 提示文字
                          hintText: '说点什么吧',
                          // 提示文本颜色
                          hintStyle: new TextStyle(
                              fontSize: ScreenUtil().setSp(26),
                              color: Color(AppColors.TEXT_HINT))),
                      autofocus: false, // 是否自动获取焦点
                    )),
                Divider(
                  height: 1,
                  color: Color(AppColors.BG_EE),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Expanded(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: images.length < 6
                            ? images.length + 1
                            : images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //横轴元素个数
                            crossAxisCount: 4,
                            //纵轴间距
                            mainAxisSpacing: 8.0,
                            //横轴间距
                            crossAxisSpacing: 8.0,
                            //子组件宽高长度比例
                            childAspectRatio: 1),
                        itemBuilder: (BuildContext context, int index) {
                          //Widget Function(BuildContext context, int index)
                          return setGridViewItem(context, index);
                        }),
                  ),
                ),
              ],
            ));
  }

  Widget setGridViewItem(BuildContext context, int index) {
    if (index < images.length) {
      return Stack(
        alignment: Alignment(0.92, -0.92),
        children: <Widget>[
          AssetThumb(
            asset: images[index],
            width: 260,
            height: 260,
          ),
          new GestureDetector(
            onTap: () async {
              setState(() {
                images.removeAt(index);
              });
            },
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: new Icon(
                Icons.close,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          )
        ],
      );
    }
    return GestureDetector(
      child: Container(
        child: Image.network(
                "http://snbc.zglcwl.com/Public/fontImages/opinion_addimg.png"),
      ),
      onTap: () {
        loadAssets();
//        showModalBottomSheet(
//          context: context,
//          builder: (BuildContext context) {
//            return createModalBottomSheetDialog(context);
//          },
//        );
      },
    );
  }

  //多图选择器
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 6,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#00a578",
            statusBarColor: "#00a578",
            actionBarTitle: "神农百草",
            allViewTitle: "所有图片",
            selectionLimitReachedText: "只能选择6张图片",
            useDetailsView: true,
            selectCircleStrokeColor: "#00a578",
          ));
    } on PlatformException catch (e) {
      print(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  var img_0, img_1, img_2, img_3, img_4, img_5;

  subject() async {
    for (int i = 0; i < images.length; i++) {
      switch (i) {
        case 0:
          ByteData byteData = await images[0].getByteData();
          var buffer = byteData.buffer;
          img_0 = base64.encode(Uint8List.view(buffer));
          break;
        case 1:
          ByteData byteData = await images[1].getByteData();
          var buffer = byteData.buffer;
          img_1 = base64.encode(Uint8List.view(buffer));
          break;
        case 2:
          ByteData byteData = await images[2].getByteData();
          var buffer = byteData.buffer;
          img_2 = base64.encode(Uint8List.view(buffer));
          break;
        case 3:
          ByteData byteData = await images[3].getByteData();
          var buffer = byteData.buffer;
          img_3 = base64.encode(Uint8List.view(buffer));
          break;
        case 4:
          ByteData byteData = await images[4].getByteData();
          var buffer = byteData.buffer;
          img_4 = base64.encode(Uint8List.view(buffer));
          break;
        case 5:
          ByteData byteData = await images[5].getByteData();
          var buffer = byteData.buffer;
          img_5 = base64.encode(Uint8List.view(buffer));
          break;
      }
      print(img_0);
    }
    DataUtils.getUserId().then((value) {
      FormData formData = new FormData.fromMap({
        "user_id": value,
        "cb_content": contentController.text,
        "img_0": img_0,
        "img_1": img_1,
        "img_2": img_2,
        "img_3": img_3,
        "img_4": img_4,
        "img_5": img_5,
      });
      Request.getInstance().post("/userCallBack", (data) async {
        setState(() {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "提交成功！");
        });
      }, params: formData);
    });
  }
}
