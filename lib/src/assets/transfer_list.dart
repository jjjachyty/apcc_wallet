import 'package:flutter/material.dart';

class TransferListPage extends StatefulWidget {
  @override
  _TransferListPageState createState() => _TransferListPageState();
}

class _TransferListPageState extends State<TransferListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("转账记录"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Text("data"),
      ),
    );
  }
}
