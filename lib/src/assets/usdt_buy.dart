import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';

class UsdtBuyPage extends StatefulWidget {
  String mainSymbol, exchangeSymbol;
  UsdtBuyPage(this.mainSymbol, this.exchangeSymbol);
  @override
  _UsdtBuyPageState createState() =>
      _UsdtBuyPageState(mainSymbol, exchangeSymbol);
}

class _UsdtBuyPageState extends State<UsdtBuyPage> {
  String mainSymbol, exchangeSymbol;
  _UsdtBuyPageState(this.mainSymbol, this.exchangeSymbol);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$mainSymbol 兑换 $exchangeSymbol")),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text("data"),
            TextFormField(
              decoration: InputDecoration(hintText: "可用USDT"),
            )
          ],
        ),
      ),
    );
  }
}
