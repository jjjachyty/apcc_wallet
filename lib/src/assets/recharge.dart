import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RechargePage extends StatelessWidget {
  String address = "";
  RechargePage(this.address);
  @override
  Widget build(BuildContext context) {
      GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: key,
        appBar: AppBar(
          title: Text("充值地址"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text.rich(
                  TextSpan(style: TextStyle(fontWeight: FontWeight.bold), text:address,children:<TextSpan>[
TextSpan(
                text: '复制',
                style: TextStyle(fontSize: 15.0, color: Colors.blue),
                recognizer:  TapGestureRecognizer()
                ..onTap = () async {
                  Clipboard.setData(ClipboardData(text: address));
                  key.currentState.showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text("已复制"),));
                }
                ),
                  ])
                ),
              
                new QrImage(
                  data: address,
                  foregroundColor: Colors.green,
                  size: 250.0,
                ),
              ],
            )));
  }
}
