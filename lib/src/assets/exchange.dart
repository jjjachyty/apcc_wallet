import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  Assets assets;
  ExchangePage(this.assets);
  @override
  _ExchangePageState createState() => _ExchangePageState(this.assets);
}

class _ExchangePageState extends State<ExchangePage> {
  Assets assets;
  _ExchangePageState(this.assets);
  @override
  Widget build(BuildContext context) {
    if (assets.code == "USDT") {
    } else {}
  }
}
