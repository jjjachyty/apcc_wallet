import 'dart:io';
import 'package:install_plugin/install_plugin.dart';
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
  @override
  void initState() {
    _findLocalPath().then((path) {
      _localPath = path + '/Download';
    });
    super.initState();
    // 初始化进度条
    ProgressDialog pr =
        new ProgressDialog(context, ProgressDialogType.Download);
    pr.setMessage('下载中…');
// 设置下载回调
    FlutterDownloader.registerCallback((id, status, progress) {
      // 打印输出下载信息
      print(
          'Download task ($id) is in status ($status) and process ($progress)');
      if (!pr.isShowing()) {
        pr.show();
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "新版本${newestVersion.versionCode}发布",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
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
              if (Platform.isIOS) {
                if (await canLaunch(newestVersion.iosDownloadUrl)) {
                  await launch(newestVersion.iosDownloadUrl);
                } else {
                  Toast.show("无法打开浏览器", context);
                }
                // gotoAppStore("");
                //ios相关代码
              } else if (Platform.isAndroid) {
                //
                download(context);
              }
            },
          )
        ],
      ),
      body: Container(
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
      ),
    );
  }
}

download(BuildContext context) async {
  if (await _checkPermission()) {
    var _downloadPath = await createPath();
    print("_downloadPath$_downloadPath");
    print("${newestVersion.androidDownloadUrl}");
    await _downloadFile(newestVersion.androidDownloadUrl, _downloadPath);

    //检测权限
  } else {
    Toast.show("授权取消,更新失败", context);
  }
}
// 获取存储路径

Future<String> _findLocalPath() async {
  // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
  // 如果是android，使用getExternalStorageDirectory
  // 如果是iOS，使用getApplicationSupportDirectory
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  return directory.path;
}

Future<String> createPath() async {
  // 获取存储路径

  final savedDir = Directory(_localPath);
// 判断下载路径是否存在
  bool hasExisted = await savedDir.exists();
// 不存在就新建路径
  if (!hasExisted) {
    savedDir.create();
  }
  return _localPath;
}

// 根据 downloadUrl 和 savePath 下载文件
_downloadFile(downloadUrl, savePath) {
  FlutterDownloader.enqueue(
    url: downloadUrl,
    savedDir: savePath,
    showNotification: false,
    fileName: "MHC.apk",
    // show download progress in status bar (for Android)
    openFileFromNotification:
        false, // click on notification to open downloaded file (for Android)
  );
}

// 申请权限
Future<bool> _checkPermission() async {
  // 先对所在平台进行判断
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

Future<String> installApk(String filePath, String appId) async {
  return await InstallPlugin.installApk(
      filePath, "com.example.apcc_wallet");
}

/// for iOS: go to app store by the url
// Future<String> gotoAppStore(String urlString) async {
//   return await InstallPlugin.gotoAppStore("www.baidu.com");
// }
