import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RechargePage extends StatelessWidget {
  Assets asset;
  RechargePage(this.asset);
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    if (asset.symbol == "USDT") {
      Future.delayed(Duration(milliseconds: 0), () {
        var dialog = CupertinoAlertDialog(
          content: Text(
            "该USDT地址是基于以太坊 ERC-20 代币协议地址,请勿使用Omni协议转账到该地址",
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text("已知晓"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );

        showDialog(context: context, builder: (_) => dialog);
      });
    }

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
                Text.rich(TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    text: asset.address.val,
                    children: <TextSpan>[
                      TextSpan(
                          text: '复制',
                          style: TextStyle(fontSize: 15.0, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Clipboard.setData(
                                  ClipboardData(text: asset.address.val));
                              key.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("已复制"),
                              ));
                            }),
                    ])),
                new QrImage(
                  data: asset.address.val,
                  foregroundColor: Colors.green,
                  size: 250.0,
                ),
              ],
            )));
  }
}
