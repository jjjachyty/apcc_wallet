import 'package:flutter/material.dart';

class MessageIndex extends StatefulWidget {
  @override
  _MessageIndexState createState() => _MessageIndexState();
}

class _MessageIndexState extends State<MessageIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("待开通"),
      ),
    );
  }
}