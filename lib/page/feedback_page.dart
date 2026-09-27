import 'dart:convert';

import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:bct_flutter/network/network.dart';
import 'package:bct_flutter/utils/DataUtils.dart';
import 'package:bct_flutter/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController contentController = TextEditingController();
  List<XFile> images = <XFile>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          //去掉Appbar底部阴影
          leading: IconButton(
              icon: Image.network(
                AppAssets.topBackBtn,
                width: 11,
                height: 19,
                fit: BoxFit.fill,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          automaticallyImplyLeading: true,
          title: Text('意见反馈'),
          backgroundColor: Color(AppColors.APP_THEME),
          centerTitle: true,
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          toolbarOpacity: 1.0,
          bottomOpacity: 1.0,
          primary: true, systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        floatingActionButton: GestureDetector(
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(AppColors.APP_THEME),
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
            SizedBox(
                height: 150,
                child: TextField(
                  // 控制器用于获取输入的内容
                  controller: contentController,
                  // 键盘格式
                  keyboardType: TextInputType.number,
                  // 光标颜色
                  cursorColor: Color(AppColors.APP_THEME),
                  // 键盘动作按钮，如“下一步”
                  textInputAction: TextInputAction.next,
                  // 键盘动作按钮点击之后执行的代码：

                  //光标切换到指定的输入框
                  onEditingComplete: () {},
                  // 文本样式
                  style: TextStyle(color: Color(AppColors.BLACK)),
                  decoration: InputDecoration(
                      // 输入框边框
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 25.w, top: 10.h),
                      // 提示文字
                      hintText: '说点什么吧',
                      // 提示文本颜色
                      hintStyle: TextStyle(
                          fontSize: 26.sp, color: Color(AppColors.TEXT_HINT))),
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
                    itemCount:
                        images.length < 6 ? images.length + 1 : images.length,
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
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(images[index].path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                images.removeAt(index);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(
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
      child: Image.asset(
          AppAssets.opinionAddimg),
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
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> selectedImages = await picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        // 限制最多6张图片
        final int maxImages = 6;
        final int currentCount = images.length;
        final int availableSlots = maxImages - currentCount;

        if (availableSlots > 0) {
          final List<XFile> imagesToAdd =
              selectedImages.take(availableSlots).toList();
          setState(() {
            images.addAll(imagesToAdd);
          });
        }
      }
    } catch (e) {
      LogUtil.d('Error picking images: $e');
    }
  }

  String? img_0, img_1, img_2, img_3, img_4, img_5;

  Future<void> subject() async {
    for (int i = 0; i < images.length; i++) {
      final bytes = await File(images[i].path).readAsBytes();
      final base64String = base64.encode(bytes);

      switch (i) {
        case 0:
          img_0 = base64String;
          break;
        case 1:
          img_1 = base64String;
          break;
        case 2:
          img_2 = base64String;
          break;
        case 3:
          img_3 = base64String;
          break;
        case 4:
          img_4 = base64String;
          break;
        case 5:
          img_5 = base64String;
          break;
      }
    }
    DataUtils.getUserId().then((value) {
      FormData formData = FormData.fromMap({
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
