import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:bct_flutter/constants/app_assets.dart';
import 'package:bct_flutter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

const debug = true;

class DownloadPage extends StatefulWidget with WidgetsBindingObserver {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  //任务列表
  List<_TaskInfo> _tasks = [];
  //项目列表
  List<_ItemHolder> _items = [];
  //是否在加载
  bool _isLoading = false;
  //用户是否同意权限
  bool _permissionReady = false;
  //存储路径
  String _localPath = '';
  //接收端口
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();

    //注册下载回调
    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    Permission.storage.request().then((value) => setState(() {
          _permissionReady = value.isGranted;
        }));
    //加载
    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    //注册接收端口监听
    _port.listen((dynamic data) {
      if (debug) {
        debugPrint('UI Isolate Callback: $data');
      }
      //任务id
      String id = data[0];
      //任务状态
      DownloadTaskStatus status = DownloadTaskStatus.values[data[1]];
      //任务进度
      int progress = data[2];

      if (_tasks.isNotEmpty) {
        //查找对应的下载任务
        final task = _tasks.firstWhere((task) => task.taskId == id);
        //更新下载任务状态和进度
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  //释放资源
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  //下载回调
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    if (debug) {
      debugPrint(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

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
        title: Text('下载'),
        backgroundColor: Color(AppColors.APP_THEME),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        primary: true,
      ),
      body: Builder(
          builder: (context) => _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _permissionReady
                  ? _buildDownloadList()
                  : _buildNoPermissionWarning()),
    );
  }

  Widget _buildDownloadList() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: _items
            .map((item) => _DownloadItem(
                  data: item,
                  onItemClick: (task) {
                    _openDownloadedFile(task).then((success) {
                      if (!mounted) return;
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('无法打开此文件')));
                      }
                    });
                  },
                  onAtionClick: (task) {
                    if (task.status == DownloadTaskStatus.undefined) {
                      _requestDownload(task);
                    } else if (task.status == DownloadTaskStatus.running) {
                      _pauseDownload(task);
                    } else if (task.status == DownloadTaskStatus.paused) {
                      _resumeDownload(task);
                    } else if (task.status == DownloadTaskStatus.complete) {
                      _delete(task);
                    } else if (task.status == DownloadTaskStatus.failed) {
                      _retryDownload(task);
                    }
                  },
                ))
            .toList(),
      );

  Widget _buildNoPermissionWarning() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '请授予访问存储权限以继续  -_-',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            TextButton(
                onPressed: () {
                  Permission.storage.request().then((value) => setState(() {
                        _permissionReady = value.isGranted;
                      }));
                },
                child: Text(
                  '重试',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ))
          ],
        ),
      );

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  void _resumeDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId!);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId!, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  //加载任务、权限、下载项目等
  Future<void> _prepare() async {
    //获取全部下载任务
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    //添加下载任务
    final list = tasks ?? const <DownloadTask>[];
    _tasks.addAll(list.map((video) {
      final String safeUrl = video.url;
      final String safeName = video.filename ?? safeUrl;
      return _TaskInfo(name: safeName, link: safeUrl);
    }));

    // _items.add(_ItemHolder(name: 'Videos'));
    for (int i = count; i < _tasks.length; i++) {
      if (_tasks[i].name != "神农百草.apk") {
        _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      }
      count++;
    }

    for (final task in list) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
          // info.imageUrl = task.imageUrl;
          debugPrint(info.link);
        }
      }
    }
    //权限是否就绪
    _permissionReady = await Permission.camera.request().isGranted;

    _localPath = '${await _findLocalPath()}${Platform.pathSeparator}Download';

    //savedDir下载文件存储位置
    final savedDir = Directory(_localPath);
    //判断目录是否存在
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      //创建目录
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
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
}

//下载项列表行
class _DownloadItem extends StatelessWidget {
  final _ItemHolder data;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo) onAtionClick;

  const _DownloadItem({
    required this.data,
    required this.onItemClick,
    required this.onAtionClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: InkWell(
        onTap: data.task.status == DownloadTaskStatus.complete
            ? () {
                onItemClick(data.task);
              }
            : null,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 64.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  data.task.imageUrl != null
                      ? Image.network(
                          data.task.imageUrl!,
                          width: 90,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : SizedBox(),
                  Expanded(
                    child: Text(
                      data.name,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildActionForTask(data.task),
                  ),
                ],
              ),
            ),
            data.task.status == DownloadTaskStatus.running ||
                    data.task.status == DownloadTaskStatus.paused
                ? Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: LinearProgressIndicator(
                      value: data.task.progress / 100,
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  //构建任务行
  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
        child: Image.asset(
          AppAssets.downloaderN,
          width: 20,
          height: 20,
          fit: BoxFit.fill,
        ),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
        child: Image.network(
          AppAssets.pauseIcon,
          width: 20,
          height: 20,
          fit: BoxFit.fill,
        ),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
        child: Image.network(
          AppAssets.playIcon,
          width: 20,
          height: 20,
          fit: BoxFit.fill,
        ),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '完成',
            style: TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
            child: Image.network(
              AppAssets.deleteImg,
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('取消', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('失败', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
            child: Image.network(
              AppAssets.refreshIcon,
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return Text('待下载', style: TextStyle(color: Colors.orange));
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String? taskId;
  String? imageUrl;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({required this.name, required this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({required this.name, required this.task});
}
