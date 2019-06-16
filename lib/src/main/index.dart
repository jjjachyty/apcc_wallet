import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xxx"),
      ),
      body: TextField(
        decoration: InputDecoration(hintText: "xxx"),
      ),
    );
  }
}
