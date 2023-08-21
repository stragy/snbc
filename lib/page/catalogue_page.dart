import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bct_flutter/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

const debug = true;

class CataloguePage extends StatefulWidget {
  CataloguePage({
    @required this.list,
  });

  var list;

  @override
  _CataloguePageState createState() => _CataloguePageState(list: list);
}

class _CataloguePageState extends State<CataloguePage> {
  _CataloguePageState({
    @required this.list,
  });

  var list;

  //存储路径
  String _localPath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //注册下载回调
    FlutterDownloader.registerCallback(downloadCallback);
    _prepare();
  }

  //加载任务、权限、下载项目等
  Future<Null> _prepare() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    print(_localPath);
    //savedDir下载文件存储位置
    final savedDir = Directory(_localPath);
    //判断目录是否存在
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      //创建目录
      savedDir.create();
    }
  }

  //下载回调
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  //获取存储目录地址
  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        //getExternalStorageDirectory,获取存储目录（android）
        ? await (getExternalStorageDirectory() as FutureOr<Directory>)
        //获取存储目录
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //去掉Appbar底部阴影
        leading: IconButton(
            icon:  CachedNetworkImage(
              width: 11,
              height: 19,
              fit: BoxFit.fill,
              imageUrl: "http://snbc.zglcwl.com/Public/fontImages/top_back_btn.png",
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: true,
        title: Text('目录'),
        backgroundColor: Color(AppColors.APP_ThEME),
        centerTitle: true,
        brightness: Brightness.dark,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        primary: true,
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Text(list != null ? list[index]['video_title'] : "",
                      style: TextStyle(
                          color: Color(AppColors.TEXT_BLACK), fontSize: 16),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 300,
                        margin: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          list != null
                              ? "本期主讲：${list[index]['video_lecturer']}"
                              : "本期主讲：暂无",
                          style: TextStyle(
                              fontSize: 14, color: Color(AppColors.Text_GRAY)),
                        )),
                    InkWell(
                      child: Container(
                        child: CachedNetworkImage(
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                          imageUrl:
                              "http://snbc.zglcwl.com/Public/fontImages/downloader_n.png",
                        ),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      onTap: () async {
                        File pdf =
                            File(_localPath + "/" + list[index]['video_title']);

                        var exist = await pdf.exists();
                        pdf.delete();
                        if (exist) {
                          Fluttertoast.showToast(msg: "此视频已下载过!");
                        } else {
                          FlutterDownloader.enqueue(
                              url: list[index]['video_url'],
                              savedDir: _localPath,
                              // imageUrl: list[index]['video_img'],
                              fileName: list[index]['video_title'],
                              showNotification: true,
                              openFileFromNotification: true);
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "请到我的下载中查看下载进度!");
                        }
                      },
                    )
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
            );
          }),
    );
  }
}
