import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RechargePage extends StatelessWidget {
  String address = "";
  RechargePage(this.address);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("充值地址"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  address,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
