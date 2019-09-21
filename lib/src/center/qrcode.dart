import 'dart:typed_data';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

import 'package:toast/toast.dart';

class MyQrCode extends StatefulWidget {
  @override
  _MyQrCodeState createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey globalKey = new GlobalKey();

  // 截图boundary，并且返回图片的二进制数据。
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("我的二维码"),
      ),
      body: Center(
          child: GestureDetector(
        child: RepaintBoundary(
            key: globalKey,
            child: Container(
              width: 250,
              height: 300,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new QrImage(
                    data: user.uuid,
                    version: QrVersions.auto,
                    size: 250,
                    foregroundColor: Colors.indigo,
                    backgroundColor: Colors.white,
                    embeddedImage: NetworkImage(avatarURL),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(50, 50),
                    ),
                  ),
                  Text(
                    "扫一扫加我为好友",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            )),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Divider(),
                      FlatButton(
                        child: Text("保存至相册"),
                        color: Colors.white,
                        onPressed: () async {
                          var permissions = await PermissionHandler()
                              .requestPermissions([PermissionGroup.storage]);

                          if (permissions[PermissionGroup.storage] ==
                              PermissionStatus.granted) {
                            var result = await ImageGallerySaver.saveImage(
                                await _capturePng());
                            if (result != null) {
                              Navigator.of(context).pop();

                              Toast.show("保存成功", context);
                            }
                          }
                        },
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.white,
              elevation: 10);
        },
      )),
    );
  }
}
