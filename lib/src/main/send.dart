import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  String barcode = "";

  scan2() {
    Future<String> futureString = new QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        // .setFrontCamera(false) // default false
        .scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("发送")),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText: "请输入转账地址",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: scan2,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
