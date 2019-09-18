import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的二维码"),
      ),
      body: Center(
        child: new QrImage(
          data: user.uuid,
          version: QrVersions.auto,
          gapless: false,
          embeddedImage: NetworkImage(avatarURL),
          foregroundColor: Colors.indigo,
          size: 320.0,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(60, 60),
          ),
        ),
      ),
    );
  }
}
