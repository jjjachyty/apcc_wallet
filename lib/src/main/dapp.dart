import 'package:flutter/material.dart';

class Dapp extends StatefulWidget {
  @override
  _DappState createState() => _DappState();
}

class _DappState extends State<Dapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("DAPP"),centerTitle: true,),
        body: Center(
          child:Text("开发中...")),
    );
  }
}