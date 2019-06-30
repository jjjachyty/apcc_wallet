import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';

class UsdtSellPage extends StatefulWidget {
  Assets assets;
  UsdtSellPage(this.assets);
  @override
  _UsdtSellPageState createState() => _UsdtSellPageState(assets);
}

class _UsdtSellPageState extends State<UsdtSellPage> {
  Assets assets;
  _UsdtSellPageState(this.assets);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("USDT->" + assets.code)),
      body: Container(
        child: Column(
          children: <Widget>[Text("data")],
        ),
      ),
    );
  }
}
