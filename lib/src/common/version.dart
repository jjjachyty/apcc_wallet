import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

var _localPath;

class VersionPage extends StatefulWidget {
  @override
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  List<_TaskInfo> _tasks;
  bool _isLoading = false;
  bool _permissionReady;
  ProgressDialog pr;
  String _localPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      FlutterDownloader.initialize().then((Null) {
        _bindBackgroundIsolate();

        FlutterDownloader.registerCallback(downloadCallback);
        _permissionReady = false;
        _prepare();
        pr = new ProgressDialog(context,
            type: ProgressDialogType.Download, isDismissible: false);
        pr.style(message: "下载中，请稍后…");
      });
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      _unbindBackgroundIsolate();
    }
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    print("_bindBackgroundIsolate");
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      setState(() {
        pr.show();
      });

      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      print(
          'Download task ($id) is in status ($status) and process ($progress)');

      if (status == DownloadTaskStatus.running) {
        pr.update(progress: progress.toDouble(), message: "下载中，请稍后…");
      }

      if (status == DownloadTaskStatus.failed) {
        Toast.show("下载异常，请稍后重试", context);
        if (pr.isShowing()) {
          pr.hide();
        }
      }
      if (status == DownloadTaskStatus.complete) {
        print(pr.isShowing());
        if (pr.isShowing()) {
          pr.hide();
          OpenFile.open(_localPath + "/MHC.apk");
          //installApk(_localPath + "/MHC.apk", "com.example.apcc_wallet");
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("新版本${newestVersion.versionCode}发布"),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/main");
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "去更新",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (Platform.isAndroid) {
                  _requestDownload(_TaskInfo(
                      name: "MHC.apk",
                      link: "${newestVersion.androidDownloadUrl}"));
                } else {
                  if (await canLaunch(newestVersion.iosDownloadUrl)) {
                    await launch(newestVersion.iosDownloadUrl);
                  } else {
                    Toast.show(
                      "无法打开浏览器",
                      context,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                }
              },
            )
          ],
        ),
        body: Builder(
            builder: (context) => _isLoading
                ? new Center(
                    child: new CircularProgressIndicator(),
                  )
                : new Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "发布时间 ${newestVersion.releaseTime}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: new MarkdownBody(
                              data:
                                  "${newestVersion.releaseNote}"), //SingleChildScrollView(child: Text("${newestVersion.releaseNote}"),) ,
                        ),
                      ],
                    ),
                  )));
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        savedDir: _localPath,
        showNotification: true,
        fileName: "MHC.apk",
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    _tasks = [];
    _tasks.add(_TaskInfo(
        name: "MHC.apk", link: "${newestVersion.androidDownloadUrl}"));

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + '/Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}
