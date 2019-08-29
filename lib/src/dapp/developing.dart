import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Developing extends StatelessWidget {
  Dapp app;
  Developing(this.app);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(app.name),centerTitle: true,),
      body: Center(
        child: Text("该Dapp正在开发中,请查看其他Dapp"),
      ),
    );
  }
}